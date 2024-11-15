# Azure Event Hubs

## 1. Configuring Event Hubs Namespace and Event Hub

[Activate](https://learn.microsoft.com/en-us/training/modules/enable-reliable-messaging-for-big-data-apps-using-event-hubs/3-exercise-create-an-event-hub-using-azure-cli) the sandbox through microsoft learn hub.

Once the sandbox activated grab the subscription and the resource group id then choose the nearest location among by sandbox allowed locations below to create event hubs:

westus2<br>
southcentralus<br>
centralus<br>
eastus<br>
westeurope<br>
southeastasia<br>
japaneast<br>
brazilsouth<br>
australiasoutheast<br>
centralindia

```sh
# Logout and login to refresh the created sandbox
az logout
az login
# Grab the subscription id of sandbox from the output
az account list --refresh --output table

# Activate the sandbox subscription
az account set --subscription {subscription_id}

# Grab the resource_group_id which is automatically created by sandbox account
az group list -o table

# Configure the default resource group and location name
az configure --defaults group="${resource_group_id}"  location={location_name from the list above like westeurope}

# Define a random NS_NAME variable to use it as an event hubs namespace name
NS_NAME=ehubns-$RANDOM

# Create azure event hubs namespace
az eventhubs namespace create --name $NS_NAME

# Give the authorization rules
az eventhubs namespace authorization-rule keys list --name RootManageSharedAccessKey --namespace-name $NS_NAME

# Define a random HUB_NAME variable to use it as an event hub name
HUB_NAME=hubname-$RANDOM

# Create azure event hub inside the namespace
az eventhubs eventhub create --name $HUB_NAME --namespace-name $NS_NAME

# You can show the information about an event hub inside a given namespace
az eventhubs eventhub show --namespace-name $NS_NAME --name $HUB_NAME
```

## 2. Configuring Storage Account

```sh
# Define a unique random storage name
STORAGE_NAME=storagename$RANDOM

# 1. Create a storage account
az storage account create --name $STORAGE_NAME --sku Standard_RAGRS --encryption-service blob


# 2. List all the access keys associated with your storage account by running the account keys list command. Copy and save the value of key for future use
az storage account keys list --account-name $STORAGE_NAME

# 3. View the connections string for your storage account running the following command. Copy and save the value of connectionString
az storage account show-connection-string -n $STORAGE_NAME

# 4. Create a container called messages in your storage account by running the following command. Use the connectionString you copied in the previous step.
az storage container create --name messages --connection-string "<connection string here>"
```

## 3. Clone the Event Hubs GitHub Repository
[View](https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/eventhub/azure-eventhub/samples) the sample app how to send with azure event hubs.
