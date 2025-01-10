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


public function main() returns error?{

     campaigns:BatchInputPublicCampaignInput inputBatchCampaignsDefinition = {
            "inputs": [
                {
                    "properties": {
                        "hs_name": "batchCampaign1_" + time:utcToString(time:utcNow()),
                        "hs_goal": "goalForBatchCampaign1"
                    }
                },
                {
                    "properties": {
                        "hs_name": "batchCampaign2_" + time:utcToString(time:utcNow()),
                        "hs_goal": "goalForBatchCampaign2"
                    }
                }
            ]
        };

    campaigns:BatchResponsePublicCampaign response = check baseClient->/batch/create.post(
        inputBatchCampaignsDefinition     
    );
    string campaignId1 = response?.results[0]?.id;
    string campaignId2 = response?.results[1]?.id;

    if campaignId1 == "" || campaignId2 == "" {
        io:println("Batch creation is not successful");
    } else {
        io:println("Batch creation is successful");
    }

    campaigns:BatchResponsePublicCampaignWithAssets|campaigns:BatchResponsePublicCampaignWithAssetsWithErrors batchReadResponse = check baseClient->/batch/read.post(
        payload = {
            "inputs": [
                { "id": campaignId1 },
                { "id": campaignId2 }
            ]
        }
    );

    if batchReadResponse?.status == "COMPLETE" {
        io:println("Batch read is successful");
    } else {
        io:println("Batch read is not successful");
    }

    var batchDeleteResponse = check baseClient->/batch/archive.post(
        payload = {
            "inputs": [
                {
                    "id": campaignId1
                },
                {
                    "id": campaignId2
                }
            ]
        }
    );

    var deleteResponse = batchDeleteResponse.statusCode;

    if deleteResponse == 204 {
        io:println("Batch deletion is successful");
    } else {
        io:println("Batch deletion is not successful");
    }
  
};