# Ballerina ebay Browse connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-ebay.browse/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-ebay.browse/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-ebay.browse.svg)](https://github.com/ballerina-platform/module-ballerinax-ebay.browse/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/ebay.browse.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Febay.browse)

## Overview

[eBay](https://www.ebay.com/) is a global online marketplace where businesses and individuals buy and sell new and used goods. The [Browse API](https://developer.ebay.com/api-docs/buy/browse/overview.html) lets buyers search for items and retrieve their details, so that applications can present eBay listings to shoppers.

The eBay Browse connector lets Ballerina applications search eBay listings by keyword, category, product identifier or image, retrieve the details of single items, multiple items and item groups, bridge legacy item IDs to Browse item IDs, and check whether an item is compatible with a given product. It supports version v1 of the Browse API.

## Setup guide

To use the eBay Browse connector, you need an eBay developer account and an application keyset. If you do not have an eBay developer account, you can sign up for one [here](https://developer.ebay.com/signin).

### Step 1: Create an application keyset

1. Sign in to the [eBay Developer Program](https://developer.ebay.com/) and open **Application Keys** from your account menu.

2. Create a keyset for the **Production** environment (or **Sandbox** for testing).

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

1. [Price comparison report](https://github.com/ballerina-platform/module-ballerinax-ebay.browse/tree/main/examples/price_comparison_report) - Search for a product, fetch the details of the cheapest listings and print a price report.

2. [Legacy item compatibility](https://github.com/ballerina-platform/module-ballerinax-ebay.browse/tree/main/examples/legacy_item_compatibility) - Resolve a legacy item ID, list the variations of its item group and check its compatibility with a product.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`ebay.browse` package](https://central.ballerina.io/ballerinax/ebay.browse/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
