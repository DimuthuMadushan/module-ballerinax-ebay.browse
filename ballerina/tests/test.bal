// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the

import ballerina/http;
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://api.ebay.com/buy/browse/v1" : "http://localhost:9090";
final string tokenUrl = isLiveServer ? "https://api.ebay.com/identity/v1/oauth2/token" : "http://localhost:9444/oauth2/token";
final string clientId = isLiveServer ? os:getEnv("EBAY_CLIENT_ID") : "mock_client_id";
final string clientSecret = isLiveServer ? os:getEnv("EBAY_CLIENT_SECRET") : "mock_client_secret";

// The OAuth2 client-credentials grant fetches a token during init, so the client is created
// after the mock listeners have started.
Client ebay = test:mock(Client);

@test:BeforeSuite
function initClient() returns error? {
    ebay = check new (
        {
            auth: {
                clientId,
                clientSecret,
                tokenUrl,
                scopes: ["https://api.ebay.com/oauth/api_scope"]
            },
            httpVersion: isLiveServer ? http:HTTP_2_0 : http:HTTP_1_1
        },
        serviceUrl
    );
}

final string testItemId = "v1|110554118437|0";
// Compatibility checks need an item in a parts category; the live run reads one from the environment.
final string compatibilityItemId = isLiveServer ? os:getEnv("EBAY_COMPATIBILITY_ITEM_ID") : testItemId;
// A complete 1x1 PNG image, Base64-encoded.
const SAMPLE_IMAGE = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==";

@test:Config {groups: ["live_tests", "mock_tests"]}
function testSearchItems() returns error? {
    SearchPagedCollection response = check ebay->searchItems({}, {q: "wallet", 'limit: "2"});
    SearchPagedCollection result = response;
    test:assertTrue(result.itemSummaries is ItemSummary[]);
    test:assertTrue((result.itemSummaries ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testSearchItemsByImage() returns error? {
    SearchPagedCollection response = check ebay->searchItemsByImage({contentType: "application/json"}, {image: SAMPLE_IMAGE}, {});
    test:assertTrue((response.itemSummaries ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetItem() returns error? {
    Item response = check ebay->getItem(testItemId, {}, {});
    test:assertTrue(response.itemId is string);
    test:assertTrue(response.title is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetItemByLegacyId() returns error? {
    Item response = check ebay->getItemByLegacyId({}, {legacyItemId: "110554118437"});
    test:assertTrue(response.itemId is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetItems() returns error? {
    Items response = check ebay->getItems({}, {itemIds: "v1|110554118437|0,v1|110554118438|0"});
    test:assertTrue((response.items ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetItemsByItemGroup() returns error? {
    ItemGroup response = check ebay->getItemsByItemGroup({}, {itemGroupId: "151982022352"});
    test:assertTrue((response.items ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCheckCompatibility() returns error? {
    CompatibilityResponse response = check ebay->checkCompatibility(
        compatibilityItemId,
        {contentType: "application/json", xEBAYCMARKETPLACEID: "EBAY_US"},
        {
            compatibilityProperties: [
                {name: "Year", value: "2018"},
                {name: "Make", value: "Toyota"},
                {name: "Model", value: "Camry"},
                {name: "Trim", value: "LE Sedan 4-Door"},
                {name: "Engine", value: "2.5L 2487CC l4 GAS DOHC Naturally Aspirated"}
            ]
        }
    );
    test:assertTrue(response.compatibilityStatus is string);
}
