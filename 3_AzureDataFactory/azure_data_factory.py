from azure.common.credentials import ServicePrincipalCredentials
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.datafactory import DataFactoryManagementClient
from azure.mgmt.datafactory.models import *
from azure.identity._constants import EnvironmentVariables
import time
from dotenv import load_dotenv
import os

# Load credentials from .env
load_dotenv()

client_id = os.environ.get(EnvironmentVariables.AZURE_CLIENT_ID)
client_secret = os.environ.get(EnvironmentVariables.AZURE_CLIENT_SECRET)
tenant_id = os.environ.get(EnvironmentVariables.AZURE_TENANT_ID)
subscription_id = os.environ.get('ARM_SUBSCRIPTION_ID')

#Create a data factory
credentials = ServicePrincipalCredentials(client_id=client_id, secret=client_secret, tenant=tenant_id)
adf_client = DataFactoryManagementClient(credentials, subscription_id)

rg_params = {'location':'germanywestcentral'}
df_params = {'location':'germanywestcentral'}

df_resource = Factory(location='germanywestcentral')

rg_name = 'resource group name'
df_name = 'data factory name'


df = adf_client.factories.create_or_update(rg_name, df_name, df_resource)

while df.provisioning_state != 'Succeeded':
    df = adf_client.factories.get(rg_name, df_name)
    time.sleep(1)
