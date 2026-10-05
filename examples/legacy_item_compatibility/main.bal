// Resolves a legacy item ID to a Browse item, lists the other variations of its item group and
// checks whether the item is compatible with a given product.

import ballerina/io;
import ballerinax/ebay.browse;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string legacyItemId = ?;
configurable string marketplaceId = "EBAY_US";
configurable string compatibilityYear = ?;
configurable string compatibilityMake = ?;
configurable string compatibilityModel = ?;

public function main() returns error? {
    browse:Client ebay = check new ({
        auth: {
            clientId,
            clientSecret
        }
    });

    // Step 1: Resolve the legacy item ID to the item in the Browse API.
    browse:Item item = check ebay->getItemByLegacyId(
        {xEBAYCMARKETPLACEID: marketplaceId},
        {legacyItemId}
    );
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
    browse:CompatibilityResponse compatibility = check ebay->checkCompatibility(
        itemId,
        {contentType: "application/json", xEBAYCMARKETPLACEID: marketplaceId},
        {
            compatibilityProperties: [
                {name: "Year", value: compatibilityYear},
                {name: "Make", value: compatibilityMake},
                {name: "Model", value: compatibilityModel}
            ]
        }
    );
    io:println("Compatibility status: ", compatibility.compatibilityStatus ?: "UNKNOWN");
}
