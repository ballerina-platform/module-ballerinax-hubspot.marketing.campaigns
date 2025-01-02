## Overview

[HubSpot](https://www.hubspot.com/our-story) is a customer platform with all the software, integrations, and resources users need to connect thier marketing, sales, and customer service.

The hubspot.marketing.campaigns package offers APIs to connect and interact with [Marketing Campaigns API](https://developers.hubspot.com/docs/reference/api/marketing/campaigns) endpoints, specifically based on HubSpot API v3.

[//]: # (TODO: Add overview mentioning the purpose of the module, supported REST API versions, and other high-level details.)

## Setup guide

To use the HubSpot Feedback connector, you must have access to the HubSpot API through a HubSpot developer account and a HubSpot App under it. Therefore you need to register for a developer account at HubSpot if you don't have one already.

### Step 1: Create/Login to a HubSpot Developer Account

If you have an account already, go to the [HubSpot developer portal](https://developers.hubspot.com/)

If you don't have a HubSpot Developer Account you can sign up to a free account [here](https://developers.hubspot.com/get-started)

### Step 2 (Optional): Create a [Developer Test Account](https://developers.hubspot.com/docs/getting-started/account-types#developer-test-accounts) under your account

Within app developer accounts, you can create developer test accounts to test apps and integrations without affecting any real HubSpot data.

*These accounts are only for development and testing purposes. In production you should not use Developer Test Accounts.*

   1. Go to Test accounts section from the left sidebar.

![](https://github.com/SamudraUduwaka/module-ballerinax-hubspot.marketing.campaigns/blob/fb6603714f9b563b74775579577749ad62726576/docs/Resources/testAccount.png)

   2. Click on the Create developer test account button on the top right corner.

![](https://github.com/SamudraUduwaka/module-ballerinax-hubspot.marketing.campaigns/blob/fb6603714f9b563b74775579577749ad62726576/docs/Resources/developmentTestAccount.png)

   3. In the pop-up window, provide a name for the test account and click on the Create button.

![](https://github.com/SamudraUduwaka/module-ballerinax-hubspot.marketing.campaigns/blob/fb6603714f9b563b74775579577749ad62726576/docs/Resources/createAccount.png)

   4. You will see the newly created test account in the list of test accounts.

![](https://github.com/SamudraUduwaka/module-ballerinax-hubspot.marketing.campaigns/blob/fb6603714f9b563b74775579577749ad62726576/docs/Resources/testAccountPortal.png)

### Step 3: Create a HubSpot App

   1. Now navigate to the Apps section from the left sidebar and click on the Create app button on the top right corner.

![](https://github.com/SamudraUduwaka/module-ballerinax-hubspot.marketing.campaigns/blob/fb6603714f9b563b74775579577749ad62726576/docs/Resources/appSection.png)

   2. Provide a public app name and description for your app.

![](https://github.com/SamudraUduwaka/module-ballerinax-hubspot.marketing.campaigns/blob/fb6603714f9b563b74775579577749ad62726576/docs/Resources/namingApp.png)

### Step 4: Setup Authentication

   1. Move to the Auth tab.

![](https://github.com/SamudraUduwaka/module-ballerinax-hubspot.marketing.campaigns/blob/fb6603714f9b563b74775579577749ad62726576/docs/Resources/auth.png)

   2. In the Scopes section, add the following scopes for your app using the Add new scopes button.
        - marketing.campaigns.read
        - marketing.campaigns.revenue.read
        - marketing.campaigns.write

![](https://github.com/SamudraUduwaka/module-ballerinax-hubspot.marketing.campaigns/blob/fb6603714f9b563b74775579577749ad62726576/docs/Resources/marketingScopes.png)

   3. In the Redirect URL section, add the redirect URL for your app. This is the URL where the user will be redirected after the authentication process. You can use localhost for testing purposes. Then hit the Create App button.

![](https://github.com/SamudraUduwaka/module-ballerinax-hubspot.marketing.campaigns/blob/fb6603714f9b563b74775579577749ad62726576/docs/Resources/redirectURL.png)

### Step 5: Get the Client ID and Client Secret

Navigate to the Auth tab and you will see the Client ID and Client Secret for your app. Make sure to save these values.

![](https://github.com/SamudraUduwaka/module-ballerinax-hubspot.marketing.campaigns/blob/fb6603714f9b563b74775579577749ad62726576/docs/Resources/clientId_secretId.png)

### Step 6: Setup Authentication Flow

Before proceeding with the Quickstart, ensure you have obtained the Access Token using the following steps:

   1. Create an authorization URL using the following format:

      ```
      https://app.hubspot.com/oauth/authorize?client_id=<YOUR_CLIENT_ID>&scope=<YOUR_SCOPES>&redirect_uri=<YOUR_REDIRECT_URI>
      ```
   Replace the <YOUR_CLIENT_ID>, <YOUR_REDIRECT_URI> and <YOUR_SCOPES> with your specific value.

   2. Paste it in the browser and select your developer test account to intall the app when prompted.

![](https://github.com/SamudraUduwaka/module-ballerinax-hubspot.marketing.campaigns/blob/fb6603714f9b563b74775579577749ad62726576/docs/Resources/accountSelect.png)

   3. A code will be displayed in the browser. Copy the code.

      ```
      Received code: na1-129d-860c-xxxx-xxxx-xxxxxxxxxxxx
      ```

   4. Run the following curl command. Replace the <YOUR_CLIENT_ID>, <YOUR_REDIRECT_URI> and <YOUR_CLIENT_SECRET> with your specific value. Use the code you received in the above step 3 as the CODE below

   - Linux/macOS
   ```bash
   curl --request POST \
--url https://api.hubapi.com/oauth/v1/token \
--header 'content-type: application/x-www-form-urlencoded' \
--data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
   ```
     
   - Windows
   ```bash
curl --request POST ^
--url https://api.hubapi.com/oauth/v1/token ^
--header 'content-type: application/x-www-form-urlencoded' ^
--data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
   ```

This command will return the access token necessary for API calls.

```json
{
  "token_type": "bearer",
  "refresh_token": "<Refresh Token>",
  "access_token": "<Access Token>",
  "expires_in": 1800
}
```

   5. Store the access token securely for use in your application.


[//]: # (TODO: Add detailed steps to obtain credentials and configure the module.)

## Quickstart

To use the HubSpot Marketing Campaigns connector in your Ballerina application, update the .bal file as follows:

### Step 1: Import the module

Import the hubspot.marketing.campaigns module and oauth2 module.

```ballerina
import ballerinax/hubspot.marketing.campaigns as hsmcampaigns;
import ballerina/oauth2;
```

### Step 2: Instantiate a new connector

   1. Create a Config.toml file and, configure the obtained credentials in the above steps as follows:

```toml
 clientId = <Client Id>
 clientSecret = <Client Secret>
 refreshToken = <Refresh Token>
```

   2. Instantiate a hsmcampaigns:ConnectionConfig with the obtained credentials and initialize the connector with it.

```ballerina
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

final hsmcampaigns:ConnectionConfig hsmcampaignsConfig = {
    auth : {
        clientId,
        clientSecret,
        refreshToken,
        credentialBearer: oauth2:POST_BODY_BEARER
    }
};

final hsmcampaigns:Client hsmcampaignsClient = check new (hsmcampaignsConfig, "https://api.hubapi.com");
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations. A sample usecase is shown below.

Create a Marketing Event

```ballerina
public function main() returns error? {
    hsmcampaigns:CollectionResponseWithTotalPublicCampaignForwardPaging campaigns = check baseClient->/marketing/v3/campaigns.get();
}
```

[//]: # (TODO: Add a quickstart guide to demonstrate a basic functionality of the module, including sample code snippets.)

## Examples

The `HubSpot Marketing Campaigns ` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-hubspot.marketing.campaigns/tree/main/examples/), covering the following use cases:

[//]: # (TODO: Add examples)
