# Legacy item compatibility

This example resolves a legacy eBay item ID to its Browse item, lists the variations of the item's group when it has one, and checks whether the item is compatible with a product described by year, make and model.

## Prerequisites

### 1. Set up an eBay application keyset

Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-ebay.browse/blob/main/ballerina/README.md#setup-guide) to obtain a client ID and client secret.

### 2. Configuration

Create a `Config.toml` file in this example's directory with the following content:

```toml
clientId = "<client-id>"
clientSecret = "<client-secret>"
legacyItemId = "<legacy-item-id>"
# For a multi-variation listing, set one of these to pick the variation. If both are empty,
# the legacy ID is looked up as an item group and its first variation is used.
legacyVariationId = ""
legacyVariationSku = ""
marketplaceId = "EBAY_US"
compatibilityYear = "2018"
compatibilityMake = "Toyota"
compatibilityModel = "Camry"
compatibilityTrim = "LE Sedan 4-Door"
compatibilityEngine = "2.5L 2487CC l4 GAS DOHC Naturally Aspirated"
compatibilitySubmodel = ""
```

The item must belong to a category that supports compatibility checks, such as vehicle parts. On `EBAY_US`, cars and trucks need `Year`, `Make`, `Model`, `Trim` and `Engine`; motorcycles need `Year`, `Make`, `Model` and `Submodel`. Empty values are left out of the request.

## Run the example

Execute the following command to run the example:

```bash
bal run
```
