# To Login with Azure CLI and set the subscription id
az login
az account set --subscription subscription_id

# Set the default location of the account to the (Europe) Germany West Central
az account list-locations -o table # To list the regions
az configure --defaults location=germanywestcentral

# To create a resource group with a rg-FirstApp name
az group create --location germanywestcentral --name rg-FirstApp
# To list all created resource groups
az group list -o table

# To create a service principle with the contributor role
az ad sp create-for-rbac --scopes /subscriptions/$subscription_id
# To list all the service principles
az ad app list -o table

# Service principle single role assignnment in the resource group level
az role assignment create --assignee {appId} --scope /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName} --role "{roleName}"
az role assignment create --assignee {appId} --scope /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName} --role "Storage Blob Data Contributor"

# Service principle contributor role assignnment in the subscription level
az role assignment create --assignee {appId} --role Contributor --scope /subscriptions/{subscriptionId}

# To create a storage account
az storage account create --name uniquestorageaccount --resource-group rg-FirstApp --location germanywestcentral --kind StorageV2

# To create a new container
az storage container create --name name
