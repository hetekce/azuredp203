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
