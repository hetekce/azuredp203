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

## 3.4. Activities and Pipelines

Activities within Azure Data Factory define the actions that will be performed on the data and there are three categories including:

- Data movement activities
- Data transformation activities
- Control activities

### Data movement activities:
Data movement activities simply move data from one data store to another. You can use the Copy Activity to perform data movement activities, or by using JSON.

### Data transformation activities:
Data transformation activities can be performed natively within the authoring tool of Azure Data Factory using the Mapping Data Flow. Alternatively, you can call a compute resource to change or enhance data through transformation, or perform analysis of the data. These include compute technologies such as Azure Databricks, Azure Batch, SQL Database and Azure Synapse Analytics, Machine Learning Services, Azure Virtual machines and HDInsight.

### Control activities:
When graphically authoring ADF solutions, you can use the control flow within the design to orchestrate pipeline activities that include chaining activities in a sequence, branching, defining parameters at the pipeline level, and passing arguments while invoking the pipeline on-demand or from a trigger.

[Find](https://learn.microsoft.com/en-us/azure/data-factory/concepts-pipelines-activities?tabs=data-factory#data-movement-activities&wt.mc_id=datainteg_egcreatedatafacmvmnt_webpage_extlp) more details about these activities and pipelines.

When using `JSON notation`, the activities section can have one or more activities defined within it. There are two main types of activities: `Execution and Control Activities`. Execution (also known as Compute) activities include data movement and data transformation activities. They have the following top-level structure:

```json
{
    "name": "Execution Activity Name",
    "description": "description",
    "type": "<ActivityType>",
    "typeProperties":
    {
    },
    "linkedServiceName": "MyLinkedService",
    "policy":
    {
    },
    "dependsOn":
    {
    }
}
```

Description of the properties as below:

![Activities](pictures/5.png)

Here is a `pipeline`:

```json
{
    "name": "PipelineName",
    "properties":
    {
        "description": "pipeline description",
        "activities":
        [
        ],
        "parameters": {
         }
    }
}
```
Description of the properties as below:

![Pipeline](pictures/6.png)

## 3.5. Integration Runtimes(IR)

Integration runtime is the `compute infrastructure` used by ADF to provide various data integration capabilities across different network environments. There `three types` of IR's offered by ADF:

`1. Azure IR:` The compute resources are fully managed elastically in Azure.

`2. Self-Hosted IR:` It can run transform activities between a cloud data store and a (on-premise) data store in a `private network`. Limination is that `Data Flows` are not supported in self-hosted IR. Use instead Azure IR for that.

`3. Azure-SQL Server Integration Services(SSIS) IR:` It is fully managed cluster of Azure VMs or nodes dedicated to run your SSIS packages.

[Find](https://learn.microsoft.com/en-us/azure/data-factory/concepts-integration-runtime) more about Integration runtime in Azure Data Factory.

[Find](https://learn.microsoft.com/en-us/azure/data-factory/connector-overview?wt.mc_id=datainteg_addtlresconnect_webpage_extlp) more about the connectors.

## 3.6. Transforming data with the Mapping Data Flow

You can natively perform data transformations with Azure Data Factory code free using the Mapping Data Flow task. Mapping Data Flows provide a fully visual experience with no coding required. Your data flows will run on your own execution cluster for scaled-out data processing.

[Find](https://learn.microsoft.com/en-us/azure/data-factory/data-flow-transformation-overview) about all data flow transformation overview.

[Find](https://learn.microsoft.com/en-us/azure/data-factory/data-flow-join?wt.mc_id=datainteg_addltlresdataflowjoin_webpage_extlp) about joins.

[See](https://learn.microsoft.com/en-us/training/modules/code-free-transformation-scale/4-author-azure-data-factory-mapping-data-flow) the example.

## 3.7. Slowly Changing Dimensions

Slowly changing dimensions (SCD) are tables in a dimensional model that handle changes to dimension values over time. Learning the best practices to design and load slowly changing dimensions will help you successfully handle changes in your data.

[Find](https://learn.microsoft.com/en-us/training/modules/populate-slowly-changing-dimensions-azure-synapse-analytics-pipelines/3-choose-between-dimension-types) more about the types of the slowly changing dimensions.

[Find](https://learn.microsoft.com/en-us/training/modules/populate-slowly-changing-dimensions-azure-synapse-analytics-pipelines/4-exercise-design-implement-type-1-dimension) more about slowly changing dimensions(SCD).


## 3.8. Continuos integration and deployment (CI/CD)

In Azure Data Factory, CI/CD means moving Data Factory pipelines from one environment (development, test, production) to another. ADF utilizes `Azure Resource Manager` templates to store the configuration of your various ADF entities (pipelines, datasets, data flows, and so on).

`Note:` Only the development factory is associated with a git repository. The test and production factories shouldn't have a git repository associated with them and should only be updated via an Azure DevOps pipeline or via a Resource Management template.

[Find](https://learn.microsoft.com/en-us/training/modules/operationalize-azure-data-factory-pipelines/4-continuous-integration-deployment) more about the ci/cd integration of ADF.

## 3.9. Monitor ADF pipelines and set up alerts

Once you've created and published a pipeline in Azure Data Factory, you can associate it with a trigger or manually kick off an on-demand run. You can monitor all of your pipeline runs natively in the Azure Data Factory user experience.

[Find](https://learn.microsoft.com/en-us/training/modules/operationalize-azure-data-factory-pipelines/5-monitor) more about monitoring.

In Azure Data Factory, you can raise alerts based upon metrics outputted by the monitoring service. Alerts allow you to get alerted for a variety of scenarios such as, but not limited to, failed pipelines, large factory sizes, and integration runtime CPU utilization.

[Find](https://learn.microsoft.com/en-us/training/modules/operationalize-azure-data-factory-pipelines/6-set-up-alerts) more about setting up alerts.

## 3.10. Azure Data Share

To share data securely with customers or other departments you can make use of Azure Data Share.

[Find](https://learn.microsoft.com/en-us/training/modules/introduction-azure-data-share/4-exercise-provision) more about how to provision.

[See](https://www.youtube.com/watch?v=fbN8pqeFtBM) the video.