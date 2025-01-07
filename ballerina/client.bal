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

import ballerina/http;

public isolated client class Client {
    final http:Client clientEp;
    final readonly & ApiKeysConfig? apiKeyConfig;
    # Gets invoked to initialize the `connector`.
    #
    # + config - The configurations to be used when initializing the `connector` 
    # + serviceUrl - URL of the target service 
    # + return - An error if connector initialization failed 
    public isolated function init(ConnectionConfig config, string serviceUrl = "https://api.hubapi.com/marketing/v3/campaigns") returns error? {
        http:ClientConfiguration httpClientConfig = {httpVersion: config.httpVersion, timeout: config.timeout, forwarded: config.forwarded, poolConfig: config.poolConfig, compression: config.compression, circuitBreaker: config.circuitBreaker, retryConfig: config.retryConfig, validation: config.validation};
        do {
            if config.http1Settings is ClientHttp1Settings {
                ClientHttp1Settings settings = check config.http1Settings.ensureType(ClientHttp1Settings);
                httpClientConfig.http1Settings = {...settings};
            }
            if config.http2Settings is http:ClientHttp2Settings {
                httpClientConfig.http2Settings = check config.http2Settings.ensureType(http:ClientHttp2Settings);
            }
            if config.cache is http:CacheConfig {
                httpClientConfig.cache = check config.cache.ensureType(http:CacheConfig);
            }
            if config.responseLimits is http:ResponseLimitConfigs {
                httpClientConfig.responseLimits = check config.responseLimits.ensureType(http:ResponseLimitConfigs);
            }
            if config.secureSocket is http:ClientSecureSocket {
                httpClientConfig.secureSocket = check config.secureSocket.ensureType(http:ClientSecureSocket);
            }
            if config.proxy is http:ProxyConfig {
                httpClientConfig.proxy = check config.proxy.ensureType(http:ProxyConfig);
            }
        }
        if config.auth is ApiKeysConfig {
            self.apiKeyConfig = (<ApiKeysConfig>config.auth).cloneReadOnly();
        } else {
            httpClientConfig.auth = <http:BearerTokenConfig|OAuth2RefreshTokenGrantConfig>config.auth;
            self.apiKeyConfig = ();
        }
        http:Client httpEp = check new (serviceUrl, httpClientConfig);
        self.clientEp = httpEp;
        return;
    }

    # Delete campaign 
    #
    # + campaignGuid - Unique identifier for the campaign, formatted as a UUID.
    # + headers - Headers to be sent with the request 
    # + return - No content 
    resource isolated function delete [string campaignGuid](map<string|string[]> headers = {}) returns http:Response|error {
        string resourcePath = string `/${getEncodedUri(campaignGuid)}`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.private\-app;
        }
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        return self.clientEp->delete(resourcePath, headers = httpHeaders);
    }

    # Remove asset association
    #
    # + campaignGuid - Unique identifier for the campaign, formatted as a UUID.
    # + assetType - The type of asset
    # Important: Currently, only the following asset types are available for disassociation via the API: FORM, OBJECT_LIST, EXTERNAL_WEB_URL
    # + assetId - Id of the asset
    # + headers - Headers to be sent with the request 
    # + return - No content 
    resource isolated function delete [string campaignGuid]/assets/[string assetType]/[string assetId](map<string|string[]> headers = {}) returns http:Response|error {
        string resourcePath = string `/${getEncodedUri(campaignGuid)}/assets/${getEncodedUri(assetType)}/${getEncodedUri(assetId)}`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.private\-app;
        }
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        return self.clientEp->delete(resourcePath, headers = httpHeaders);
    }

    # Campaign search
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function get .(map<string|string[]> headers = {}, *GetMarketingV3CampaignsQueries queries) returns CollectionResponseWithTotalPublicCampaignForwardPaging|error {
        string resourcePath = string `/`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.private\-app;
        }
        map<Encoding> queryParamEncoding = {"properties": {style: FORM, explode: true}};
        resourcePath = resourcePath + check getPathForQueryParam(queries, queryParamEncoding);
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        return self.clientEp->get(resourcePath, httpHeaders);
    }

    # Read a campaign
    #
    # + campaignGuid - Unique identifier for the campaign, formatted as a UUID.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function get [string campaignGuid](map<string|string[]> headers = {}, *GetMarketingV3CampaignsCampaignguidQueries queries) returns PublicCampaignWithAssets|error {
        string resourcePath = string `/${getEncodedUri(campaignGuid)}`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.private\-app;
        }
        map<Encoding> queryParamEncoding = {"properties": {style: FORM, explode: true}};
        resourcePath = resourcePath + check getPathForQueryParam(queries, queryParamEncoding);
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        return self.clientEp->get(resourcePath, httpHeaders);
    }

    # List assets
    #
    # + campaignGuid - Unique identifier for the campaign, formatted as a UUID.
    # + assetType - The type of asset to fetch.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function get [string campaignGuid]/assets/[string assetType](map<string|string[]> headers = {}, *GetMarketingV3CampaignsCampaignguidAssetsAssettypeQueries queries) returns CollectionResponsePublicCampaignAssetForwardPaging|error {
        string resourcePath = string `/${getEncodedUri(campaignGuid)}/assets/${getEncodedUri(assetType)}`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.private\-app;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        return self.clientEp->get(resourcePath, httpHeaders);
    }

    # Read budget
    #
    # + campaignGuid - Unique identifier for the campaign, formatted as a UUID.
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function get [string campaignGuid]/budget/totals(map<string|string[]> headers = {}) returns PublicBudgetTotals|error {
        string resourcePath = string `/${getEncodedUri(campaignGuid)}/budget/totals`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.private\-app;
        }
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        return self.clientEp->get(resourcePath, httpHeaders);
    }

    # Fetch contact IDs
    #
    # + campaignGuid - Unique identifier for the campaign, formatted as a UUID.
    # + contactType - The type of metric to filter the influenced contacts. Allowed values: contactFirstTouch, contactLastTouch, influencedContacts
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function get [string campaignGuid]/reports/contacts/[string contactType](map<string|string[]> headers = {}, *GetMarketingV3CampaignsCampaignguidReportsContactsContacttypeQueries queries) returns CollectionResponseContactReferenceForwardPaging|error {
        string resourcePath = string `/${getEncodedUri(campaignGuid)}/reports/contacts/${getEncodedUri(contactType)}`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.private\-app;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        return self.clientEp->get(resourcePath, httpHeaders);
    }

    # Get Campaign Metrics
    #
    # + campaignGuid - Unique identifier for the campaign, formatted as a UUID.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function get [string campaignGuid]/reports/metrics(map<string|string[]> headers = {}, *GetMarketingV3CampaignsCampaignguidReportsMetricsQueries queries) returns MetricsCounters|error {
        string resourcePath = string `/${getEncodedUri(campaignGuid)}/reports/metrics`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.private\-app;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        return self.clientEp->get(resourcePath, httpHeaders);
    }

    # Fetch revenue
    #
    # + campaignGuid - Unique identifier for the campaign, formatted as a UUID.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function get [string campaignGuid]/reports/revenue(map<string|string[]> headers = {}, *GetMarketingV3CampaignsCampaignguidReportsRevenueQueries queries) returns RevenueAttributionAggregate|error {
        string resourcePath = string `/${getEncodedUri(campaignGuid)}/reports/revenue`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.private\-app;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        return self.clientEp->get(resourcePath, httpHeaders);
    }

    # Update campaign
    #
    # + campaignGuid - Unique identifier for the campaign, formatted as a UUID.
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function patch [string campaignGuid](PublicCampaignInput payload, map<string|string[]> headers = {}) returns PublicCampaign|error {
        string resourcePath = string `/${getEncodedUri(campaignGuid)}`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.private\-app;
        }
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->patch(resourcePath, request, httpHeaders);
    }

    # Create a campaign
    #
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function post .(PublicCampaignInput payload, map<string|string[]> headers = {}) returns PublicCampaign|error {
        string resourcePath = string `/`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.private\-app;
        }
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Delete a batch of campaigns
    #
    # + headers - Headers to be sent with the request 
    # + return - No content 
    resource isolated function post batch/archive(BatchInputPublicCampaignDeleteInput payload, map<string|string[]> headers = {}) returns http:Response|error {
        string resourcePath = string `/batch/archive`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.private\-app;
        }
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Create a batch of campaigns
    #
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function post batch/create(BatchInputPublicCampaignInput payload, map<string|string[]> headers = {}) returns BatchResponsePublicCampaign|BatchResponsePublicCampaignWithErrors|error {
        string resourcePath = string `/batch/create`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.private\-app;
        }
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Read a batch of campaigns
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function post batch/read(BatchInputPublicCampaignReadInput payload, map<string|string[]> headers = {}, *PostMarketingV3CampaignsBatchReadQueries queries) returns BatchResponsePublicCampaignWithAssets|BatchResponsePublicCampaignWithAssetsWithErrors|error {
        string resourcePath = string `/batch/read`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.private\-app;
        }
        map<Encoding> queryParamEncoding = {"properties": {style: FORM, explode: true}};
        resourcePath = resourcePath + check getPathForQueryParam(queries, queryParamEncoding);
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Update a batch of campaigns
    #
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function post batch/update(BatchInputPublicCampaignBatchUpdateItem payload, map<string|string[]> headers = {}) returns BatchResponsePublicCampaign|BatchResponsePublicCampaignWithErrors|error {
        string resourcePath = string `/batch/update`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.private\-app;
        }
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Add asset association
    #
    # + campaignGuid - Unique identifier for the campaign, formatted as a UUID
    # + assetType - The type of asset
    # Important: Currently, only the following asset types are available for association via the API: FORM, OBJECT_LIST, EXTERNAL_WEB_URL
    # + assetId - Id of the asset
    # + headers - Headers to be sent with the request 
    # + return - No content 
    resource isolated function put [string campaignGuid]/assets/[string assetType]/[string assetId](map<string|string[]> headers = {}) returns http:Response|error {
        string resourcePath = string `/${getEncodedUri(campaignGuid)}/assets/${getEncodedUri(assetType)}/${getEncodedUri(assetId)}`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.private\-app;
        }
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);
        http:Request request = new;
        return self.clientEp->put(resourcePath, request, httpHeaders);
    }
}
