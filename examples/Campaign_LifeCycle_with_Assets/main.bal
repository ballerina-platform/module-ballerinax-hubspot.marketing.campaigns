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

import ballerina/io;
import ballerina/oauth2;
import ballerina/time;
import ballerinax/hubspot.marketing.campaigns;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

configurable string serviceUrl = "https://api.hubapi.com/marketing/v3/campaigns";

campaigns:OAuth2RefreshTokenGrantConfig authConfig = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

campaigns:ConnectionConfig config = {auth: authConfig};

final campaigns:Client baseClient = check new (config);

configurable string assetType = ?;
configurable string assetID = ?;

public function main() returns error?{

     campaigns:PublicCampaignInput inputCampaignDefinition = {
            properties: {
                "hs_name": "campaign" + time:utcNow().toString(),
                "hs_goal": "campaignGoalSpecified",
                "hs_notes": "someNotesForTheCampaign"
            }
        };

    campaigns:PublicCampaign response = check baseClient->/.post(
        inputCampaignDefinition     
    );

    string campaignId = response?.id;

    if campaignId == "" {
        io:println("Campaign creation is not successful");
    } else {
        io:println("Campaign creation is successful");
        io:println("Campaign ID: " + campaignId);
    }

    var addAssetResponse = check baseClient->/[campaignId]/assets/[assetType]/[assetID].put();
    
    if addAssetResponse.statusCode == 204 {
        io:println("Asset association is successful");
    } else {
        io:println("Asset association is not successful");
    }

    campaigns:CollectionResponsePublicCampaignAssetForwardPaging assetListResponse = check baseClient->/[campaignId]/assets/[assetType];
    
    if assetListResponse.results.length() > 0 {
        io:println("Asset list retrieval is successful");
        io:println("Asset ID: " + assetListResponse.results[0].id);
    } else {
        io:println("Asset list retrieval is not successful");
    }

    var assetRemoveResponse = check baseClient->/[campaignId]/assets/[assetType]/[assetID].delete();
    
    if assetRemoveResponse.statusCode == 204 {
        io:println("Asset removal is successful");
    } else {
        io:println("Asset removal is not successful");
    }

    var deleteCampaignResponse = check baseClient->/[campaignId].delete();

    if deleteCampaignResponse.statusCode == 204 {
        io:println("Batch deletion is successful");
    } else {
        io:println("Batch deletion is not successful");
    }
  
};