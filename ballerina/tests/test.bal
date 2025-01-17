// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
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
// specific language governing permissions and limitations
// under the License.

import ballerina/oauth2;
import ballerina/os;
import ballerina/test;
import ballerina/time;

configurable boolean enableClient0auth2 = os:getEnv("IS_LIVE_SERVER") == "false";
configurable string clientId = enableClient0auth2 ? os:getEnv("CLIENT_ID") : "test";
configurable string clientSecret = enableClient0auth2 ? os:getEnv("CLIENT_SECRET") : "test";
configurable string refreshToken = enableClient0auth2 ? os:getEnv("REFRESH_TOKEN") : "test";

// configurable string clientId = ?;
// configurable string clientSecret = ?;
// configurable string refreshToken = ?;

OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

final Client hsmCampaignsClient = check new ({auth: enableClient0auth2 ? auth : {token: "Bearer token"}});

string campaignGuid2 = "";
configurable string campaignGuid = ?;
configurable string assetType = ?;
configurable string assetID = ?;

configurable string sampleCampaignGuid1 = ?;
configurable string sampleCampaignGuid2 = ?;
configurable string sampleCampaignGuid3 = ?;
configurable string sampleCampaignGuid4 = ?;

@test:Config {
    groups: ["live_tests"]
}
isolated function testGetSearchMarketingCampaigns() returns error? {
    CollectionResponseWithTotalPublicCampaignForwardPaging response = check hsmCampaignsClient->/.get();
    test:assertTrue(response?.results.length() > 0);
}

@test:Config {
    groups: ["live_tests"],
    enable: enableClient0auth2
}
function testPostCreateMarketingCampaigns() returns error? {
    PublicCampaign response = check hsmCampaignsClient->/.post(
        payload = {
            properties: {
                "hs_name": "campaign" + time:utcNow().toString(),
                "hs_goal": "campaignGoalSpecified",
                "hs_notes": "someNotesForTheCampaign"
            }
        }
    );
    test:assertNotEquals(response?.id, "");
    campaignGuid2 = response?.id;
}

@test:Config {
    groups: ["live_tests"],
    enable: enableClient0auth2
}
isolated function testGetReadACampaign() returns error? {
    PublicCampaignWithAssets response = check hsmCampaignsClient->/[campaignGuid];
    test:assertEquals(response?.id, campaignGuid);
}

@test:Config {
    groups: ["live_tests"],
    enable: enableClient0auth2
}
isolated function testPatchUpdateCampaigns() returns error? {
    PublicCampaign response = check hsmCampaignsClient->/[campaignGuid].patch(
        payload = {
            properties: {
                "hs_goal": "updatedCampaignGoal",
                "hs_notes": "updatedNotesForTheCampaign"
            }
        }
    );
    test:assertEquals(response?.id, campaignGuid);
}

@test:Config {
    groups: ["live_tests"],
    enable: enableClient0auth2
}
isolated function testPostBatchCreate() returns error? {
    BatchResponsePublicCampaign|BatchResponsePublicCampaignWithErrors response = check hsmCampaignsClient->/batch/create.post(
        payload = {
            "inputs": [
                {
                    "properties": {
                        "hs_name": "batchCampaign" + time:utcToString(time:utcNow()),
                        "hs_goal": "batchCampaignGoalSpecified"
                    }
                }
            ]
        }
    );
    test:assertEquals(response?.status, "COMPLETE");
}

@test:Config {
    groups: ["live_tests"],
    enable: enableClient0auth2
}
isolated function testPostBatchUpdate() returns error? {
    BatchResponsePublicCampaign|BatchResponsePublicCampaignWithErrors response = check hsmCampaignsClient->/batch/update.post(
        payload = {
            "inputs": [
                {
                    "id": sampleCampaignGuid1,
                    "properties": {
                        "hs_goal": "updatedGoal",
                        "hs_notes": "updatedNote"
                    }
                }
            ]
        }
    );
    test:assertEquals(response?.status, "COMPLETE");
}

@test:Config {
    groups: ["live_tests"],
    enable: enableClient0auth2
}
isolated function testPostBatchRead() returns error? {
    BatchResponsePublicCampaignWithAssets|BatchResponsePublicCampaignWithAssetsWithErrors response =
        check hsmCampaignsClient->/batch/read.post(
        payload = {
            "inputs": [
                {
                    "id": sampleCampaignGuid2
                }
            ]
        }
    );
    test:assertEquals(response?.status, "COMPLETE");
}

@test:Config {
    groups: ["live_tests"],
    enable: enableClient0auth2
}
isolated function testGetReportsRevenue() returns error? {
    RevenueAttributionAggregate response = check hsmCampaignsClient->/[campaignGuid]/reports/revenue;
    test:assertTrue(response?.revenueAmount is decimal);
}

@test:Config {
    groups: ["live_tests"],
    enable: enableClient0auth2
}
isolated function testGetReportsMetrics() returns error? {
    MetricsCounters response = check hsmCampaignsClient->/[campaignGuid]/reports/metrics;
    test:assertTrue(response?.sessions >= 0);
}

@test:Config {
    groups: ["live_tests"],
    enable: enableClient0auth2
}
isolated function testGetListAssets() returns error? {
    CollectionResponsePublicCampaignAssetForwardPaging response = check hsmCampaignsClient->/[campaignGuid]/assets/[assetType];
    test:assertTrue(response?.results.length() > 0);

}

@test:Config {
    dependsOn: [testDeleteRemoveAssetAssociation],
    groups: ["live_tests"],
    enable: enableClient0auth2
}
isolated function testPutAddAssetAssociation() returns error? {
    var response = check hsmCampaignsClient->/[campaignGuid]/assets/[assetType]/[assetID].put();
    test:assertEquals(response.statusCode, 204);
}

@test:Config {
    dependsOn: [testGetListAssets],
    groups: ["live_tests"],
    enable: enableClient0auth2
}
isolated function testDeleteRemoveAssetAssociation() returns error? {
    var response = check hsmCampaignsClient->/[campaignGuid]/assets/[assetType]/[assetID].delete();
    test:assertEquals(response.statusCode, 204);
}

@test:Config {
    dependsOn: [testPostCreateMarketingCampaigns],
    groups: ["live_tests"],
    enable: enableClient0auth2
}
function testDeleteCampaign() returns error? {
    var response = check hsmCampaignsClient->/[campaignGuid2].delete();
    test:assertEquals(response.statusCode, 204);
}

@test:Config {
    groups: ["live_tests"],
    enable: enableClient0auth2
}
isolated function testPostDeleteABatchOfCampaigns() returns error? {
    var response = check hsmCampaignsClient->/batch/archive.post(
        payload = {
            "inputs": [
                {
                    "id": sampleCampaignGuid3
                },
                {
                    "id": sampleCampaignGuid4
                }
            ]
        }
    );
    test:assertEquals(response.statusCode, 204);
}
