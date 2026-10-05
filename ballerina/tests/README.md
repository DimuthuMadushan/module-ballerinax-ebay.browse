# Running Tests

## Prerequisites

To run the tests against the live eBay Browse API you need an eBay developer application keyset (client ID and client secret). Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-ebay.browse/blob/main/ballerina/README.md#setup-guide) to obtain them.

## Test environments

There are two test environments. The default is a mock server for the Browse API, together with a mock OAuth token endpoint. The other is the live eBay Browse API.

 Test Groups | Environment
-------------|------------------------------------------------
 mock_tests  | Mock server for the Browse API (default)
 live_tests  | eBay Browse API

## Running tests against the mock server

No configuration is needed. When `IS_LIVE_SERVER` is not set to `true`, the tests run against the mock server on port `9090` and the mock token endpoint on port `9444`.

```bash
./gradlew clean test
```

## Running tests against the live API

Set the following environment variables and run the live test group:

```bash
export IS_LIVE_SERVER=true
export EBAY_CLIENT_ID=<client-id>
export EBAY_CLIENT_SECRET=<client-secret>
./gradlew clean test -Pgroups=live_tests
```

The live tests only read public data. The compatibility test needs an item that supports compatibility checks (for example a vehicle part), so adjust `testItemId` in `tests/test.bal` accordingly.
