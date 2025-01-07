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
import ballerina/test;
import ballerina/time;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

configurable string serviceUrl = "https://api.hubapi.com/marketing/v3/campaigns";

OAuth2RefreshTokenGrantConfig authConfig = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

ConnectionConfig config = {auth: authConfig};

final Client baseClient = check new Client(config, serviceUrl = serviceUrl);

//Variables
string campaignGuid2 = "" ;
configurable string campaignGuid = ?;
configurable string assetType = ?;
configurable string assetID = ?;

@test:Config {}
isolated function testGetSearchMarketingCampaigns() returns error? {
    CollectionResponseWithTotalPublicCampaignForwardPaging response = check baseClient->/.get();
    test:assertTrue(response?.results.length() > 0);
}

@test:Config {}
function testPostCreateMarketingCampaigns() returns error? {
    PublicCampaign response = check baseClient->/.post(
        payload = {properties: {
            "hs_name": "campaign" + time:utcNow().toString() ,
            "hs_goal": "campaignGoalSpecified",
            "hs_notes": "someNotesForTheCampaign"
        }}
    );
    test:assertTrue(response?.id != "");
    campaignGuid2 = response?.id;
}

@test:Config {}
isolated function testGetReadACampaign() returns error? {
    PublicCampaignWithAssets response = check baseClient->/[campaignGuid];
    test:assertTrue(response?.id == campaignGuid);
}

@test:Config {}
isolated function testPatchUpdateCampaigns() returns error? {
    PublicCampaign response = check baseClient->/[campaignGuid].patch(
        payload = {properties: {
            "hs_goal": "updatedCampaignGoal",
            "hs_notes": "updatedNotesForTheCampaign"
        }}
    );
    test:assertTrue(response?.id == campaignGuid);
}

@test:Config {}
isolated function testPostBatchCreate() returns error? {
    BatchResponsePublicCampaign|BatchResponsePublicCampaignWithErrors response = check baseClient->/batch/create.post(
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
    test:assertTrue(response?.status == "COMPLETE");
}

@test:Config {}
isolated function  testPostBatchRead() returns error? {
    BatchResponsePublicCampaignWithAssets|BatchResponsePublicCampaignWithAssetsWithErrors response = check baseClient->/batch/read.post(
        payload = {
                "inputs": [
                    {
                        "id": "ef46bced-1a75-42b5-9f5f-ebdd39cbfd3b"
                    }
                ]
            }
    );
    test:assertTrue(response?.status == "COMPLETE");
}

@test:Config {}
isolated function testGetReportsRevenue() returns error? {
    RevenueAttributionAggregate response = check baseClient->/[campaignGuid]/reports/revenue;
    test:assertTrue(response?.revenueAmount is decimal);
}

@test:Config {}
isolated function testGetReportsMetrics() returns error? {
    MetricsCounters response = check baseClient->/[campaignGuid]/reports/metrics;
    test:assertTrue(response?.sessions == 0);
}

@test:Config {}
isolated function  testGetListAssets() returns error? {
    CollectionResponsePublicCampaignAssetForwardPaging response = check baseClient->/[campaignGuid]/assets/[assetType];
    test:assertTrue(response?.results.length() > 0);
    
}

@test:Config {}
isolated function  testPutAddAssetAssociation() returns error? {
    var response = check baseClient->/[campaignGuid]/assets/[assetType]/[assetID].put();
    test:assertTrue(response.statusCode == 204);
}

@test:Config {
    dependsOn: [testPutAddAssetAssociation, testGetListAssets]
}
isolated function  testDeleteRemoveAssetAssociation() returns error? {
    var response = check baseClient->/[campaignGuid]/assets/[assetType]/[assetID].delete();
    test:assertTrue(response.statusCode == 204);
}

@test:Config {
    dependsOn: [testPostCreateMarketingCampaigns]
}
function  testDeleteCampaign() returns error? {
    var response = check baseClient->/[campaignGuid2].delete();
    test:assertTrue(response.statusCode == 204);
}

@test:Config {}
isolated function testPostDeleteABatchOfCampaigns() returns error? {
    var response = check baseClient->/batch/archive.post(
        payload = {
            "inputs": [
                {
                    "id": "b3e493b0-9d5a-4b3e-a362-f4e0f015345d"
                },
                {
                    "id": "96a87dab-554a-474c-853b-c78193a8b889"
                }
            ]
        }
    );
    test:assertTrue(response.statusCode == 204);
}
