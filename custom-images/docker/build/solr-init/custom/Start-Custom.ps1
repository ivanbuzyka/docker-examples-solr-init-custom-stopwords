param(
    [Parameter(Mandatory)]
    [string]$SitecoreSolrConnectionString,

    [Parameter(Mandatory)]
    [string]$SolrSitecoreConfigsetSuffixName,

    [Parameter(Mandatory)]
    [string]$SolrCorePrefix,

    [Parameter(Mandatory)]
    [string]$SolrReplicationFactor,

    [Parameter(Mandatory)]
    [int]$SolrNumberOfShards,
    
    [Parameter(Mandatory)]
    [int]$SolrMaxShardsPerNodes,

    [string]$SolrXdbSchemaFile,
    
    [string]$SolrCollectionsToDeploy
)

$contextPath = "C:\data"

.\Start.ps1 -SitecoreSolrConnectionString $SitecoreSolrConnectionString -SolrCorePrefix $SolrCorePrefix -SolrSitecoreConfigsetSuffixName $SolrSitecoreConfigsetSuffixName -SolrReplicationFactor $SolrReplicationFactor -SolrNumberOfShards $SolrNumberOfShards -SolrMaxShardsPerNodes $SolrMaxShardsPerNodes -SolrXdbSchemaFile .\\data\\schema.json -SolrCollectionsToDeploy $SolrCollectionsToDeploy

. .\Get-SolrCredential.ps1

$solrContext = .\Parse-ConnectionString.ps1 -SitecoreSolrConnectionString $SitecoreSolrConnectionString

$SolrEndpoint = $solrContext.SolrEndpoint
$env:SOLR_USERNAME = $solrContext.SolrUsername
$env:SOLR_PASSWORD = $solrContext.SolrPassword

# Load configs from json
$configs = $null
if (Test-Path -Path "$contextPath\configs.json") {
    $configs = ((Get-Content "$contextPath\configs.json" | Out-String | ConvertFrom-Json).configs)
}

# Create or update all configs
foreach ($config in $configs) {
    .\Update-SolrConfig.ps1 -SolrEndpoint $SolrEndpoint -SolrConfigName $config.name -SolrConfigDir "$contextPath\$($config.path)"
}

# Load collections from json
$solrCores = $null
if (Test-Path -Path "$contextPath\collections.json") {
    $solrCores = ((Get-Content "$contextPath\collections.json" | Out-String | ConvertFrom-Json).collections)
}

# Create new collections
$solrCollections = (Invoke-RestMethod -Uri "$SolrEndpoint/admin/collections?action=LIST&omitHeader=true" -Method Get -Credential (Get-SolrCredential)).collections
foreach ($solrCore in $solrCores) {   
    if ($solrCollections -contains $solrCore.name) {
        .\Reload-SolrCollection.ps1 -SolrEndpoint $SolrEndpoint -SolrCollectionName $solrCore.name
        
        Write-Information -MessageData "$($solrCore.name) already exists and has been reloaded." -InformationAction:Continue
        continue
    }
        
    .\New-SolrCollection.ps1 -SolrEndpoint $SolrEndpoint -SolrCollectionName $solrCore.name -SolrConfigsetName $solrCore.config -SolrReplicationFactor $SolrReplicationFactor -SolrNumberOfShards $SolrNumberOfShards -SolrMaxShardNumberPerNode $SolrMaxShardsPerNodes

    if ($solrCore.alias) {
        .\New-SolrAlias.ps1 -SolrEndpoint $SolrEndpoint -SolrCollectionName $solrCore.name -AliasName $solrCore.alias
    }
}