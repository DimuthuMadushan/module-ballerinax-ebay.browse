## Overview

[eBay](https://www.ebay.com/) is a global online marketplace where businesses and individuals buy and sell new and used goods. The [Browse API](https://developer.ebay.com/api-docs/buy/browse/overview.html) lets buyers search for items and retrieve their details, so that applications can present eBay listings to shoppers.

The eBay Browse connector lets Ballerina applications search eBay listings by keyword, category, product identifier or image, retrieve the details of single items, multiple items and item groups, bridge legacy item IDs to Browse item IDs, and check whether an item is compatible with a given product. It supports version v1 of the Browse API.

### Key features

- Search eBay listings by keyword, category, GTIN, ePID, charity or aspects, with filtering, sorting and pagination
- Search for listings that look like a supplied image
- Retrieve full item details, individually or in bulk, including pricing, shipping, seller and return terms
- Browse the variations of an item group, such as colors and sizes
- Convert legacy eBay item IDs to Browse item IDs
- Check whether a part or accessory is compatible with a specific product

## Setup guide

To use the eBay Browse connector, you need an eBay developer account and an application keyset. If you do not have an eBay developer account, you can sign up through the [eBay Developer Program signup](https://developer.ebay.com/signin).

### Step 1: Create an application keyset

1. Sign in to the [eBay Developer Program](https://developer.ebay.com/) and open **Application Keys** from your account menu.

2. Create a keyset for the **Production** environment. The connector targets the Production endpoints (`https://api.ebay.com/buy/browse/v1` and its token URL) by default, so the quickstart below uses Production credentials only.

3. Note down the **App ID (Client ID)** and the **Cert ID (Client Secret)** of the keyset.

### Step 2: Understand the authorization

The Browse API uses the OAuth 2.0 client credentials grant. The connector exchanges the client ID and client secret for an application access token and refreshes it automatically. The token is requested with the `https://api.ebay.com/oauth/api_scope` scope, which grants access to public eBay data.

## Quickstart

To use the eBay Browse connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `ebay.browse` module.

```ballerina
import ballerinax/ebay.browse;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and configure the credentials obtained in the steps above:

```toml
clientId = "<Client ID>"
clientSecret = "<Client Secret>"
```

2. Create a `browse:ConnectionConfig` with the OAuth 2.0 client credentials and initialize the connector with it.

```ballerina
configurable string clientId = ?;
configurable string clientSecret = ?;

final browse:Client ebay = check new ({
    auth: {
        clientId,
        clientSecret
    }
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### Search for items

```ballerina
public function main() returns error? {
    browse:SearchPagedCollection _ = check ebay->searchItems({}, {q: "leather wallet", 'limit: "10"});
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The eBay Browse connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-ebay.browse/tree/main/examples/), covering the following use cases:

1. [Price comparison report](https://github.com/ballerina-platform/module-ballerinax-ebay.browse/tree/main/examples/price_comparison_report) - Search for a product and print a price report of the cheapest listings.

2. [Legacy item compatibility](https://github.com/ballerina-platform/module-ballerinax-ebay.browse/tree/main/examples/legacy_item_compatibility) - Resolve a legacy item ID, list the variations of its item group and check its compatibility with a product.
