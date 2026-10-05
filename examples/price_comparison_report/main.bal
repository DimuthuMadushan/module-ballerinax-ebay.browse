// Searches eBay for a product, then fetches full details for the cheapest matches to build a price report.

import ballerina/io;
import ballerinax/ebay.browse;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string searchKeyword = ?;
configurable string marketplaceId = "EBAY_US";
configurable int maxResults = 5;

public function main() returns error? {
    browse:Client ebay = check new ({
        auth: {
            clientId,
            clientSecret
        }
    });

    // Step 1: Search fixed-price listings for the keyword, cheapest first.
    browse:SearchPagedCollection results = check ebay->searchItems(
        {xEBAYCMARKETPLACEID: marketplaceId},
        {
            q: searchKeyword,
            filter: "buyingOptions:{FIXED_PRICE}",
            sort: "price",
            'limit: maxResults.toString()
        }
    );
    browse:ItemSummary[] summaries = results.itemSummaries ?: [];
    if summaries.length() == 0 {
        return error(string `No listings found for '${searchKeyword}'`);
    }
    io:println(string `Found ${results.total ?: summaries.length()} listings, reporting on ${summaries.length()}`);

    // Step 2: Fetch the full details of the matches in a single call.
    string[] itemIds = [];
    foreach browse:ItemSummary summary in summaries {
        string? itemId = summary.itemId;
        if itemId is string {
            itemIds.push(itemId);
        }
    }
    browse:Items details = check ebay->getItems(
        {xEBAYCMARKETPLACEID: marketplaceId},
        {itemIds: string:'join(",", ...itemIds)}
    );

    // Step 3: Print the report.
    foreach browse:CoreItem item in details.items ?: [] {
        browse:ConvertedAmount? price = item.price;
        string priceText = price is browse:ConvertedAmount ? string `${price.value ?: "?"} ${price.currency ?: ""}` : "n/a";
        string sellerText = item.seller?.username ?: "unknown seller";
        io:println(string `${item.title ?: "Untitled"} | ${item.condition ?: "n/a"} | ${priceText} | ${sellerText}`);
    }
}
