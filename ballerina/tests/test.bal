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

final Client baseClient = check new (config);

string campaignGuid2 = "";
configurable string campaignGuid = ?;
configurable string assetType = ?;
configurable string assetID = ?;

configurable string sampleCampaignGuid1 = ?;
configurable string sampleCampaignGuid2 = ?;
configurable string sampleCampaignGuid3 = ?;
configurable string sampleCampaignGuid4 = ?;


//SearchMarketingCampaigns
@test:Config {}
isolated function testGetSearchMarketingCampaigns() returns error? {
    CollectionResponseWithTotalPublicCampaignForwardPaging response = check baseClient->/.get();
    test:assertTrue(response?.results.length() > 0);
}

//CreateMarketingCampaigns
@test:Config {}
function testPostCreateMarketingCampaigns() returns error? {
    PublicCampaign response = check baseClient->/.post(
        payload = {
            properties: {
                "hs_name": "campaign" + time:utcNow().toString(),
                "hs_goal": "campaignGoalSpecified",
                "hs_notes": "someNotesForTheCampaign"
            }
        }
    );
    test:assertNotEquals(response?.id , "");
    campaignGuid2 = response?.id;
}

//Read a Marketing Campaign
@test:Config {}
isolated function testGetReadACampaign() returns error? {
    PublicCampaignWithAssets response = check baseClient->/[campaignGuid];
    test:assertEquals(response?.id , campaignGuid);
}

//Update a Marketing Campaign
@test:Config {}
isolated function testPatchUpdateCampaigns() returns error? {
    PublicCampaign response = check baseClient->/[campaignGuid].patch(
        payload = {
            properties: {
                "hs_goal": "updatedCampaignGoal",
                "hs_notes": "updatedNotesForTheCampaign"
            }
        }
    );
    test:assertEquals(response?.id , campaignGuid);
}

//Create a Batch of Marketing Campaigns
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
    test:assertEquals(response?.status , "COMPLETE");
}

//Update a Batch of Marketing Campaigns
@test:Config {}
isolated function testPostBatchUpdate() returns error? {
    BatchResponsePublicCampaign|BatchResponsePublicCampaignWithErrors response = check baseClient->/batch/update.post(
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
    test:assertEquals(response?.status , "COMPLETE");
}

//Read a Batch of Marketing Campaigns
@test:Config {}
isolated function testPostBatchRead() returns error? {
    BatchResponsePublicCampaignWithAssets|BatchResponsePublicCampaignWithAssetsWithErrors response = check baseClient->/batch/read.post(
        payload = {
            "inputs": [
                {
                    "id": sampleCampaignGuid2
                }
            ]
        }
    );
    test:assertEquals(response?.status , "COMPLETE");
}

//Get Reports - Revenue
@test:Config {}
isolated function testGetReportsRevenue() returns error? {
    RevenueAttributionAggregate response = check baseClient->/[campaignGuid]/reports/revenue;
    test:assertTrue(response?.revenueAmount is decimal);
}

//Reports Metrics
@test:Config {}
isolated function testGetReportsMetrics() returns error? {
    MetricsCounters response = check baseClient->/[campaignGuid]/reports/metrics;
    test:assertTrue(response?.sessions >= 0);
}

//List Assets Associated with a Campaign
@test:Config {}
isolated function testGetListAssets() returns error? {
    CollectionResponsePublicCampaignAssetForwardPaging response = check baseClient->/[campaignGuid]/assets/[assetType];
    test:assertTrue(response?.results.length() > 0);

}

//Add an Asset Association to a Campaign
@test:Config {
    dependsOn: [testDeleteRemoveAssetAssociation]
}
isolated function testPutAddAssetAssociation() returns error? {
    var response = check baseClient->/[campaignGuid]/assets/[assetType]/[assetID].put();
    test:assertEquals(response.statusCode , 204);
}

//Remove an Asset Association from a Campaign
@test:Config {
    dependsOn: [testGetListAssets]
}
isolated function testDeleteRemoveAssetAssociation() returns error? {
    var response = check baseClient->/[campaignGuid]/assets/[assetType]/[assetID].delete();
    test:assertEquals(response.statusCode , 204);
}

//Delete a Marketing Campaign
@test:Config {
    dependsOn: [testPostCreateMarketingCampaigns]
}
function testDeleteCampaign() returns error? {
    var response = check baseClient->/[campaignGuid2].delete();
    test:assertEquals(response.statusCode , 204);
}

//Delete a Batch of Marketing Campaigns
@test:Config {}
isolated function testPostDeleteABatchOfCampaigns() returns error? {
    var response = check baseClient->/batch/archive.post(
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
    test:assertEquals(response.statusCode , 204);
}
