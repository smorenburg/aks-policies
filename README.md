# Astro

## Deploying the resources

**Step 1:** Connect to Azure and set the context. Replace `subscriptionID` with the subscription identifier.

```powershell
Connect-AzAccount
```

```powershell
Set-AzContext <subscriptionID>
```

**Step 2:** Create the storage account for the Terraform state. Copy the storage account name.

```powershell
./scripts/Create-StorageAccount.ps1
```

**Step 3:** Set the variables. Replace `storage_account` with the storage account name.

```bash
export STORAGE_ACCOUNT=<storage_account>
````

```bash
export APP="astro"
export LOCATION="northeurope"
export ENVIRONMENT="dev"
export RESOURCE_GROUP="rg-tfstate-astro-neu"
````

```bash
export TF_VAR_app=${APP}
export TF_VAR_location=${LOCATION}
export TF_VAR_environment=${ENVIRONMENT}
export TF_VAR_resource_group=${RESOURCE_GROUP}
export TF_VAR_storage_account=${STORAGE_ACCOUNT}
```

**Step 4:** Initialize Terraform for each section.

```bash
cd terraform/shared && \
terraform init \
  -backend-config="storage_account_name=${STORAGE_ACCOUNT}" \
  -backend-config="resource_group_name=${RESOURCE_GROUP}" \
  -backend-config="key=${LOCATION}.tfstate"
````

```bash
cd ../environment && \
terraform init \
  -backend-config="storage_account_name=${STORAGE_ACCOUNT}" \
  -backend-config="resource_group_name=${RESOURCE_GROUP}" \
  -backend-config="key=${ENVIRONMENT}.${LOCATION}.tfstate"
````

**Step 5:** Deploy the resources for each section.

```bash
cd ../shared && \
terraform apply -auto-approve
```

```bash
cd ../environment && \
terraform apply -auto-approve
```

**Step 5:** Install the Radius (rad) CLI.

```bash
curl -fsSL "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.sh" | /bin/bash
```

**Step 6:** Connect to the cluster.

**Step 7:** Initialize Radius

```bash
rad init
```

## Destroying the resources.

**Step 1:** Destroy the resources for each section.

```bash
cd terraform/shared && \
terraform destroy -auto-approve
```

```bash
cd ../environment && \
terraform destroy -auto-approve
```
