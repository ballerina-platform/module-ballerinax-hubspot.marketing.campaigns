# Examples

The `ballerinax/hubspot.marketing.campaigns` connector provides practical examples illustrating usage in various scenarios.

1. [Batch_of_Campaigns](examples/Batch_of_Campaigns)
2. [Campaign_LifeCycle_with_Assets](examples/Campaign_LifeCycle_with_Assets)

## Prerequisites

1. Setup Hubspot account
Refer to the Setup guide in [README.md](README.md) file to set up your hubspot account, if you do not have one.

2. Configuration
Update your Zendesk account related configurations in the Config.toml file in the example root directory:

clientId = ''
clientSecret = ''
refreshToken = ''

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
