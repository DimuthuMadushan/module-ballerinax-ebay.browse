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
marketplaceId = "EBAY_US"
compatibilityYear = "<year, e.g. 2018>"
compatibilityMake = "<make, e.g. Toyota>"
compatibilityModel = "<model, e.g. Camry>"
```

The item must belong to a category that supports compatibility checks, such as vehicle parts.

## Run the example

Execute the following command to run the example:

```bash
bal run
```
