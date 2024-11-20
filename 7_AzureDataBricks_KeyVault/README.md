# 7. Azure Databricks

## 7.1. Magic Commands

* Magic Commands are specific to the Databricks notebooks
* A single percent (%) symbol at the start of a cell identifies a Magic Commands

* **&percnt;python** -> Runs the cell with python
* **&percnt;scala** -> Runs the cell with scala
* **&percnt;sql** -> Runs the cell with sql
* **&percnt;r** -> Runs the cell with R
* **&percnt;sh** -> Runs the cell as a linux shell
* **&percnt;run** -> You can run a notebook from another notebook. All variables & functions defined in that other notebook will become available in your current notebook.
* **&percnt;fs** -> Runs the cell as Databricks File System(DBFS).

## 7.2. Databricks Utilities - dbutils

* You can access the DBFS through the Databricks Utilities class (and other file IO routines).
* An instance of DBUtils is already declared for us as `dbutils`.
* For in-notebook documentation on DBUtils you can execute the command `dbutils.help()`.

## 7.3. Azure Databricks Secrets UI

Now that you have an instance of Azure Key Vault up and running, it is time to let Azure Databricks know how to connect to it.

The first step is to open a new web browser tab and navigate to `https://<your_azure_databricks_url>#secrets/createScope`

The number after the `?o=` is the unique workspace identifier; append `#secrets/createScope` to this.

<img src="https://files.training.databricks.com/images/adbcore/config-keyvault/db-secrets.png" width=800px />

