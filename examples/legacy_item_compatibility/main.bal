// Resolves a legacy item ID to a Browse item, lists the other variations of its item group and
// checks whether the item is compatible with a given product.

import ballerina/io;
import ballerinax/ebay.browse;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string legacyItemId = ?;
// For a multi-variation listing, identify the variation by its legacy variation ID or SKU.
// Leave both empty to treat the legacy ID as an item group and use its first variation.
configurable string legacyVariationId = "";
configurable string legacyVariationSku = "";
configurable string marketplaceId = "EBAY_US";
// Compatibility properties of the product. On EBAY_US, cars and trucks need Trim and Engine,
// and motorcycles need Submodel, alongside Year, Make and Model. Empty values are not sent.
configurable string compatibilityYear = ?;
configurable string compatibilityMake = ?;
configurable string compatibilityModel = ?;
configurable string compatibilityTrim = "";
configurable string compatibilityEngine = "";
configurable string compatibilitySubmodel = "";

public function main() returns error? {
    browse:Client ebay = check new ({
        auth: {
            clientId,
            clientSecret
        }
    });

    // Step 1: Resolve the legacy item ID to the item in the Browse API.
    browse:Item item;
    if legacyVariationId != "" || legacyVariationSku != "" {
        item = check ebay->getItemByLegacyId(
            {xEBAYCMARKETPLACEID: marketplaceId},
            {
                legacyItemId,
                legacyVariationId: legacyVariationId == "" ? () : legacyVariationId,
                legacyVariationSku: legacyVariationSku == "" ? () : legacyVariationSku
            }
        );
    } else {
        browse:Item|error single = ebay->getItemByLegacyId({xEBAYCMARKETPLACEID: marketplaceId}, {legacyItemId});
        if single is browse:Item {
            item = single;
        } else {
            // The legacy ID of a multi-variation listing is its item group ID.
            browse:ItemGroup group = check ebay->getItemsByItemGroup(
                {xEBAYCMARKETPLACEID: marketplaceId},
                {itemGroupId: legacyItemId}
            );
            browse:Item[] groupItems = group.items ?: [];
            if groupItems.length() == 0 {
                return error(string `No item or item group found for ${legacyItemId}`, single);
            }
            item = groupItems[0];
        }
    }
    string? resolvedId = item.itemId;
    if resolvedId is () {
        return error("The item has no Browse item ID");
    }
    string itemId = resolvedId;
    io:println(string `Resolved ${legacyItemId} to ${itemId}: ${item.title ?: "Untitled"}`);

    // Step 2: List the variations of the item's group, if it belongs to one.
    browse:ItemGroupSummary? group = item.primaryItemGroup;
    string? groupId = group?.itemGroupId;
    if groupId is string {
        browse:ItemGroup variations = check ebay->getItemsByItemGroup(
            {xEBAYCMARKETPLACEID: marketplaceId},
            {itemGroupId: groupId}
        );
        foreach browse:Item variation in variations.items ?: [] {
            io:println(string `Variation ${variation.itemId ?: "?"}: ${variation.color ?: "n/a"} ${variation.size ?: ""}`);
        }
    } else {
        io:println("The item is not part of an item group");
    }

    // Step 3: Check compatibility with the requested product.
    [string, string][] properties = [
        ["Year", compatibilityYear],
        ["Make", compatibilityMake],
        ["Model", compatibilityModel],
        ["Trim", compatibilityTrim],
        ["Engine", compatibilityEngine],
        ["Submodel", compatibilitySubmodel]
    ];
    browse:CompatibilityResponse compatibility = check ebay->checkCompatibility(
        itemId,
        {contentType: "application/json", xEBAYCMARKETPLACEID: marketplaceId},
        {
            compatibilityProperties: from [string, string] [name, value] in properties
                where value != ""
                select {name, value}
        }
    );
    io:println("Compatibility status: ", compatibility.compatibilityStatus ?: "UNKNOWN");
}
