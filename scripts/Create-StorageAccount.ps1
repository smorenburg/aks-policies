$resourceGroupName = "rg-tfstate-astro-neu"
$location = "northeurope"
$storageAccountSuffix = "stastro"
$random = -Join ("abcdefghijklmnopqrstuwvxyz0123456789".tochararray() | Get-Random -Count 6 | ForEach-Object { [char]$PSItem })
$storageAccountName = $storageAccountSuffix + $random

New-AzResourceGroup -Name $resourceGroupName -Location $location

$account = @{
    ResourceGroupName = $resourceGroupName
    Name = $storageAccountName
    Location = $location
    SkuName = "Standard_RAGRS"
    MinimumTlsVersion = "TLS1_2"
}

New-AzStorageAccount @account

$context = New-AzStorageContext -StorageAccountName $storageAccountName -UseConnectedAccount

New-AzStorageContainer -Name tfstate -Context $context