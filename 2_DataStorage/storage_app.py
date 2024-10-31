from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient, BlobBlock, StandardBlobTier
from dotenv import load_dotenv
from azure.core.exceptions import ResourceExistsError
from typing import Literal
import io
import os
import uuid


# Asyncio
# import asyncio
# from azure.identity.aio import DefaultAzureCredential
# from azure.storage.blob.aio import BlobServiceClient, BlobClient, ContainerClient

# Acquire a credential object
load_dotenv()
token_credential = DefaultAzureCredential()


async def create_blob_storage(storage_account_name, storage_type: Literal['blob', 'queue', 'table', 'file']):
    
    account_url = f"https://{storage_account_name}.{storage_type}.core.windows.net"
    
    
    async with BlobServiceClient(account_url, credential=token_credential) as blob_service_client:
        container_client = blob_service_client.get_container_client(container="sample-container")
        return container_client


def get_blob_service_client_token_credential(storage_account_name, storage_type: Literal['blob', 'queue', 'table', 'file'] = 'blob'):
    account_url = f"https://{storage_account_name}.{storage_type}.core.windows.net"

    # Create the BlobServiceClient object
    blob_service_client = BlobServiceClient(account_url, credential=token_credential)

    return blob_service_client

def create_blob_root_container(blob_service_client: BlobServiceClient, storage_account_name: str):
    container_client = blob_service_client.get_container_client(container="$root")

    # Create the root container if it doesn't already exist
    if not container_client.exists():
        container_client.create_container()    

def create_blob_container(blob_service_client: BlobServiceClient, container_name: str):
    try:
        container_client = blob_service_client.create_container(name=container_name)
        print(f'container has been created:\n{container_client}')
    except ResourceExistsError:
        print('A container with this name already exists')

def upload_blob_file(blob_service_client: BlobServiceClient, container_name: str):
    
    container_client = blob_service_client.get_container_client(container=container_name)
    with open(file="pictures\\1.png", mode="rb") as data:
        # container_client.upload_blob(name="sample-blob.txt", data=data, overwrite=True)
        container_client.upload_blob(name="1.png", data=data, overwrite=True)
        print(f"Image uploaded to blob storage: '{storage_account_name}'")



if __name__=='__main__':
    storage_account_name = "uniquestorageaccount"
    container_name = "sample-container"
    
    blob_service_client = get_blob_service_client_token_credential(storage_account_name)
    
    create_blob_container(blob_service_client, container_name)
    
    upload_blob_file(blob_service_client, container_name)
