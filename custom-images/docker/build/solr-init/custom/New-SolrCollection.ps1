param(
    [Parameter(Mandatory)]
    [string]$SolrEndpoint,

    [Parameter(Mandatory)]
    [string]$SolrCollectionName,

    [Parameter(Mandatory)]
    [string]$SolrConfigsetName,

    [Parameter(Mandatory)]
    [string]$SolrReplicationFactor,

    [Parameter(Mandatory)]
    [string]$SolrNumberOfShards,
        
    [Parameter(Mandatory)]
    [string]$SolrMaxShardNumberPerNode,

    $SolrCollectionAliases
)
function Invoke-SolrWebRequest {
    param (
        [Parameter(Mandatory)]
        [string]$Uri
    )

    return Invoke-RestMethod -Credential (Get-SolrCredential) -Uri $Uri `
        -ContentType "application/json" -Method Post
}

Write-Host "Creating $solrCollectionName SOLR collection"

$solrUrl = [System.String]::Concat($SolrEndpoint, "/admin/collections?action=CREATE&name=", $SolrCollectionName , 
    "&collection.configName=", $SolrConfigsetName, "&replicationFactor=", $SolrReplicationFactor, 
    "&numShards=", $SolrNumberOfShards, "&maxShardsPerNode=", $SolrMaxShardNumberPerNode, "&property.update.autoCreateFields=false")
$null = Invoke-SolrWebRequest -Uri $solrUrl