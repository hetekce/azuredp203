# 3. Azure Data Factory

`Azure Data Factory` provides a cloud-based data integration service that `orchestrates` the movement and transformation of data between various data stores and compute resources.

![ETL](pictures/1.png)

ADF Components:

![Azure Data Factory Components](pictures/2.png)

To connect to external resources Data Factory uses a `Linked Service`.

## 3.1 Provision of Azure Data Factory with Terraform

[Download and install terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform) if it's not already installed.

Let's remember, how to use terraform commands.

```sh
terraform init  # Initialization of terraform
terraform plan  # See the changes before deployment

terraform apply # `<FILENAME>.auto.tfvars` applied by default
terraform apply -var-file=another-variable-file.tfvars  # Apply a different variable file
terraform apply -var="db_pass=$DB_PASS_ENV_VAR" # Passing Variables via CLI(don't forget the export the variable beforehand)

# To print out the specific output variables
terraform output output_name 

# To destroy all created resources
terraform destroy
```

Since we should not push the secrets in git, i put `.tfvars` in `.gitignore`. They consists of these variables below. You can assign your credentials to the variables.

```tfvars
# secrets.auto.tfvars
client_id       = ""
client_secret   = ""
tenant_id       = ""
subscription_id = ""
```

```tfvars
# terraform.auto.tfvars
adf_name            = ""
resource_group_name = ""
location            = ""
```

## 3.2. Create Linked Services


A linked service in Data Factory can be defined using the Copy Data Activity in the ADF designer, or you can create them independently to point to a data store or a compute resources. The Copy Activity copies data between the source and destination, and when you run this activity you are asked to define a linked service as part of the copy activity definition

Alternatively you can programmatically define a linked service in the JSON format to be used via REST APIs or the SDK, using the following notation:

```json
{
    "name": "<Name of the linked service>",
    "properties": {
        "type": "<Type of the linked service>",
        "typeProperties": {
              "<data store or compute-specific type properties>"
        },
        "connectVia": {
            "referenceName": "<name of Integration Runtime>",
            "type": "IntegrationRuntimeReference"
        }
    }
}
```

Description of the properties as below:

![Linked Services](pictures/3.png)


## 3.3. Create Datasets

A dataset is a named view of data that simply points or references the data you want to use in your activities as inputs and outputs. Datasets identify data within different data stores, such as tables, files, folders, and documents. For example, an Azure Blob dataset specifies the blob container and folder in Blob storage from which the activity should read the data.
A dataset in Data Factory can be defined as an object within the Copy Data Activity, as a separate object, or in a JSON format for programmatic creation as follows:

```json
{
    "name": "<name of dataset>",
    "properties": {
        "type": "<type of dataset: AzureBlob, AzureSql etc...>",
        "linkedServiceName": {
                "referenceName": "<name of linked service>",
                "type": "LinkedServiceReference",
        },
        "schema": [
            {
                "name": "<Name of the column>",
                "type": "<Name of the type>"
            }
        ],
        "typeProperties": {
            "<type specific property>": "<value>",
            "<type specific property 2>": "<value 2>",
        }
    }
}
```

Description of the properties as below:

![Datasets](pictures/4.png)
