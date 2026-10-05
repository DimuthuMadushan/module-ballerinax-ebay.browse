# Examples

The `ballerinax/ebay.browse` connector provides practical examples illustrating usage in various scenarios.

1. **[Price comparison report](https://github.com/ballerina-platform/module-ballerinax-ebay.browse/tree/main/examples/price_comparison_report)** - Search for a product and print a price report of the cheapest listings.

2. **[Legacy item compatibility](https://github.com/ballerina-platform/module-ballerinax-ebay.browse/tree/main/examples/legacy_item_compatibility)** - Resolve a legacy item ID, list the variations of its item group and check its compatibility with a product.

## Prerequisites

1. Create an eBay application keyset to authenticate the connector as described in the [Setup guide](https://central.ballerina.io/ballerinax/ebay.browse/latest#setup-guide).

2. For each example, create a `Config.toml` file with the related configuration. Here's an example of how your Config.toml file should look:

```toml
clientId = "<client-id>"
clientSecret = "<client-secret>"
```

Each example lists the additional values it needs in its own README.

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
