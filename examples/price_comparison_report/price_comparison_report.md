# Price comparison report

This example searches eBay for fixed-price listings of a product, sorted by price, and prints a short price report of the cheapest matches with each item's title, condition, price and seller.

## Prerequisites

### 1. Set up an eBay application keyset

Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-ebay.browse/blob/main/ballerina/README.md#setup-guide) to obtain a client ID and client secret.

### 2. Configuration

Create a `Config.toml` file in this example's directory with the following content:

```toml
clientId = "<client-id>"
clientSecret = "<client-secret>"
searchKeyword = "<product-keyword, e.g. leather wallet>"
marketplaceId = "EBAY_US"
maxResults = 5
```

## Run the example

Execute the following command to run the example:

```bash
bal run
```
