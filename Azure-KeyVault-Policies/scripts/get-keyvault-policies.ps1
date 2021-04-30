################################################################################################################################################################
### Gets existing Key Vault access polcies
###
### Usage:
### get-keyvault-policies.ps1 -keyVaultName $(keyVaultName) -outputName $(outputName)
################################################################################################################################################################

param(
	[Parameter(Mandatory = $true)]
	[string]
	$keyVaultName,
	[Parameter(Mandatory = $true)]
	[string]
	$outputName
)

$keyVaultAccessPolicies = az keyvault show -n $keyVaultName | jq -r .properties.accessPolicies | ConvertFrom-Json

$armAccessPolicies = @()

if($keyVaultAccessPolicies)
{
	foreach($keyVaultAccessPolicy in $keyVaultAccessPolicies) {
		$armAccessPolicy = [pscustomobject]@{
			tenantId = $keyVaultAccessPolicy.TenantId
			objectId = $keyVaultAccessPolicy.ObjectId
		}

		$armAccessPolicyPermissions = [pscustomobject]@{
			keys = $keyVaultAccessPolicy.permissions.keys
			secrets = $keyVaultAccessPolicy.permissions.secrets
			certificates = $keyVaultAccessPolicy.permissions.certificates
		}

		$armAccessPolicy | Add-Member -MemberType NoteProperty -Name permissions -Value $armAccessPolicyPermissions

		$armAccessPolicies += $armAccessPolicy
   	}
}

$armAccessPoliciesParameter = [pscustomobject]@{
	list = $armAccessPolicies
}

$armAccessPoliciesParameter = $armAccessPoliciesParameter | ConvertTo-Json -Depth 5 -Compress

Write-Output "##vso[task.setvariable variable=$outputName]$armAccessPoliciesParameter"
