_Author_:  Samudra Uduwaka \
_Created_: 2025-01-02 \
_Updated_: 2025-01-07 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from HubSpot Marketing Campaigns . 
The OpenAPI specification is obtained from [Hubspot Marketing Campaings API](https://developers.hubspot.com/docs/reference/api/marketing/campaigns).


[//]: # (TODO: Add sanitation details)
1.  Change the url property of the servers object:

    Original: https://api.hubapi.com 

    Updated: https://api.hubapi.com/marketing/v3/campaigns 

    Reason: This change is made to ensure that all API paths are relative to the versioned base URL (/marketing/v3/campaigns), which improves the consistency and usability of the APIs.

2.  Update API Paths:

    Original: Paths included the version prefix in each endpoint (e.g., /marketing/v3/campaigns/batch/read ).

    Updated: Paths are modified to remove the version prefix from the endpoints, as it is now included in the base URL. For example:

    - Original: /marketing/v3/campaigns/batch/read 

    - Updated: /batch/read 

    Reason: This modification simplifies the API paths, making them shorter and more readable. It also centralizes the versioning to the base URL, which is a common best practice.

3.  Updated `PublicCampaignAsset` Object:

    Removed `metrics` property from the required properties.

    Definitions: 

    - Previous Definition:

        ```json
        "PublicCampaignAsset" : {
            "required" : [ "id", "metrics"],
            "type" : "object",
            "properties" : {
            "name" : {
                "type" : "string"
            },
            "id" : {
                "type" : "string"
            },
            "metrics" : {
                "type" : "object",
                "additionalProperties" : {
                "type" : "number"
                }
            }
            }
        }
        ```

    - After

        ```json
        "PublicCampaignAsset" : {
            "required" : [ "id"],
            "type" : "object",
            "properties" : {
            "name" : {
                "type" : "string"
            },
            "id" : {
                "type" : "string"
            },
            "metrics" : {
                "type" : "object",
                "additionalProperties" : {
                "type" : "number"
                }
            }
            }
        }
        ```

    Reason: `metrics` property is not required when creating and retrieving.



## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.json --mode client --license docs/license.txt -o ballerina
```
Note: The license year is hardcoded to 2024, change if necessary.
