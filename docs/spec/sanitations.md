_Author_:  @DimuthuMadushan \
_Created_: 05-10-2026 \
_Updated_: 05-10-2026 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from eBay Browse.
The OpenAPI specification is obtained from [wso2/api-specs](https://github.com/wso2/api-specs/blob/main/openapi/ebay/browse/v1.20.4/openapi.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

## Sanitization Details

1. **Operation summaries added**: The original spec has no `summary` on any operation. Added one per operation:
   - `GET /item_summary/search`: "Search items"
   - `POST /item_summary/search_by_image`: "Search items by image"
   - `GET /item/{item_id}`: "Get item"
   - `GET /item/get_item_by_legacy_id`: "Get item by legacy ID"
   - `GET /item/`: "Get multiple items"
   - `GET /item/get_items_by_item_group`: "Get items by item group"
   - `POST /item/{item_id}/check_compatibility`: "Check item compatibility"
   - **Reason**: Client method documentation is derived from the summary.

2. **Generic `200` response descriptions rewritten**: The `OK` and `Success` descriptions on the seven `200` responses were replaced with descriptions of the returned payload (for example "Summaries of items matching the search criteria").
   - **Reason**: The description becomes the `# + return` documentation of the client method.

3. **Missing schema descriptions added**: Added a `description` to `Amount`, `AspectGroup`, `AutoCorrections`, `AvailableCoupon`, `PaymentMethod` and `PaymentMethodBrand`.
   - **Reason**: These schemas had no description, so the generated record types were undocumented.

4. **Request body description added**: The `POST /item/{item_id}/check_compatibility` request body had no description; it is described as "Product compatibility details to check against the item" in the aligned spec.
   - **Reason**: Documents the `payload` parameter of the client method.

5. **Operation IDs renamed**: `search` is now `searchItems` and `searchByImage` is now `searchItemsByImage`. The other five operation IDs are unchanged (`getItem`, `getItemByLegacyId`, `getItems`, `getItemsByItemGroup`, `checkCompatibility`).
   - **Reason**: `search` is too generic for a client method. The decisions are persisted in `ai-mappings.json`.

6. **Schema renamed**: `ItemLocationImpl` is now `ItemLocation`. All other schema names are kept.
   - **Reason**: Removes an implementation suffix from a public type name. Persisted in `ai-mappings.json`.

7. **Path parameter naming**: `bal openapi align` renames the path parameter `item_id` to `itemId`, and the other snake_case query and header parameters keep their wire names through `@http:Query` / `@http:Header` annotations.
   - **Reason**: Idiomatic Ballerina identifiers.

8. **Security scheme**: The original `api_auth` OAuth 2.0 client credentials scheme is kept unchanged. The generated `ConnectionConfig` defaults `tokenUrl` to `https://api.ebay.com/identity/v1/oauth2/token`.

9. **Server URL variable inlined**: The server `https://api.ebay.com{basePath}` with the variable `basePath` (default `/buy/browse/v1`) was replaced by the plain URL `https://api.ebay.com/buy/browse/v1`.
   - **Reason**: The generated client's default `serviceUrl` is then the same as the spec's server URL.

10. **HTML stripped from descriptions and summaries**: Converted the HTML in every `description` and `summary` to plain text with `tooling/sanitize_spec.py --strip-html`: 4,195 tags (`<br>`, `<b>`, `<code>`, `<a>`, `<ul>`, `<li>`, `<span>`, `<pre>`, ...) in 314 descriptions. Tags were removed and their inner text kept, links keep their text and drop the URL, `<br>`, `<p>` and `<li>` became line breaks (list items start with `- `), and entities such as `&lt;` and `&amp;` were decoded. Examples, enums, defaults, patterns and keys were not touched.
   - **Reason**: The raw HTML ended up verbatim in the generated doc comments of `client.bal` and `types.bal`.

11. **`info.description` shortened**: Replaced the multi-paragraph marketing text (resource list, legacy API bridge note and token requirement) with "The eBay Buy Browse API lets applications search for items by keyword, category, GTIN or image, retrieve item details, and check item compatibility."
   - **Reason**: `info.description` becomes the doc comment of the generated `Client` class.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json --mode client --license docs/license.txt --client-methods remote -o ballerina
```

Note: The license year is hardcoded to 2026, change if necessary.
