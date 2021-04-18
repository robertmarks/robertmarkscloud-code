using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)
$secret = $env:keyVaultSecret

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

$body = "Your Key Vault secret is: ${secret}"

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
