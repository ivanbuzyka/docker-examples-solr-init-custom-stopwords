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

Write-Host "Deleting $solrCollectionName SOLR collection"

$solrUrl = [System.String]::Concat($SolrEndpoint, "/admin/collections?action=DELETE&name=", $SolrCollectionName, "&omitHeader=true")
$null = Invoke-SolrWebRequest -Uri $solrUrl