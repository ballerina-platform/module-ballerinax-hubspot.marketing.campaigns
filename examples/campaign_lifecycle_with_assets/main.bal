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

campaigns:OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

final campaigns:Client hubspotMarketingCampaigns = check new ({auth});

configurable string assetType = ?;
configurable string assetID = ?;

public function main() returns error? {

    campaigns:PublicCampaignInput inputCampaignDefinition = {
        properties: {
            "hs_name": "campaign" + time:utcNow().toString(),
            "hs_goal": "campaignGoalSpecified",
            "hs_notes": "someNotesForTheCampaign"
        }
    };

    campaigns:PublicCampaign response = check hubspotMarketingCampaigns->/.post(
        inputCampaignDefinition
    );

    string campaignId = response?.id;

    if campaignId == "" {
        io:println("Campaign creation is not successful");
    } else {
        io:println(string `Campaign with id "${campaignId}" created successfully`);
    }

    _ = check hubspotMarketingCampaigns->/[campaignId]/assets/[assetType]/[assetID].put();
    io:println("Asset association is successful");

    campaigns:CollectionResponsePublicCampaignAssetForwardPaging assetListResponse =
        check hubspotMarketingCampaigns->/[campaignId]/assets/[assetType];

    if assetListResponse.results.length() > 0 {
        io:println("Asset list retrieval is successful");
        io:println("Asset ID: " + assetListResponse.results[0].id);
    } else {
        io:println("Asset list retrieval is not successful");
    }

    _ = check hubspotMarketingCampaigns->/[campaignId]/assets/[assetType]/[assetID].delete();
    io:println("Asset disassociation is successful");

    _ = check hubspotMarketingCampaigns->/[campaignId].delete();
    io:println("Campaign deletion is successful");

};
