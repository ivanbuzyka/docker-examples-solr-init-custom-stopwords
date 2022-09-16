param(
    [Parameter(Mandatory)]
    [string]$SolrEndpoint,

    [Parameter(Mandatory)]
    [string]$SolrCollectionName
)
function Invoke-SolrWebRequest {
    param (
        [Parameter(Mandatory)]
        [string]$Uri
    )

    return Invoke-RestMethod -Credential (Get-SolrCredential) -Uri $Uri `
        -ContentType "application/json" -Method Post
}

Write-Host "Reloading $SolrCollectionName"
$webUrl = '{0}/admin/collections?action=RELOAD&name={1}' -f $SolrEndpoint, $SolrCollectionName
$null = Invoke-SolrWebRequest -Uri $webUrl