param(

    [Parameter(Mandatory)]
    [string]$SolrEndpoint,
    
    [Parameter(Mandatory)]
    [string]$SolrConfigName
)

Write-Host "Delete '$SolrConfigName' SOLR config set"
$solrPostConfigUrl = "$SolrEndpoint/admin/configs?action=DELETE&name=$SolrConfigName&omitHeader=true"
$null = Invoke-RestMethod -Uri $solrPostConfigUrl -Method Post -Credential (Get-SolrCredential) -ContentType "application/json"