param(

    [Parameter(Mandatory)]
    [string]$SolrEndpoint,
    
    [Parameter(Mandatory)]
    [string]$SolrConfigName,

    [Parameter(Mandatory)]
    [string]$SolrConfigDir
)

function Compress-7zip {
    param(
        $Path,
        $DestinationPath
    )
    Start-Process -NoNewWindow -Wait C:\7-Zip\7z.exe -ArgumentList a, $DestinationPath, $Path
    return $DestinationPath
}

# check if the configset exists
$solrListEndpointUrl = "$SolrEndpoint/admin/configs?action=LIST"
$configSets = (Invoke-RestMethod -Uri $solrListEndpointUrl -Credential (Get-SolrCredential) -Method Get).configSets
if ($configSets -contains $SolrConfigName) {
    # config set exists, therefore it should be downloaded, updated and re-created together with collection
    Write-Host "Config set '$SolrConfigName' exists. Start it's updating"

    $zkcli = ".\solr-8.8.2\server\scripts\cloud-scripts\zkcli.bat"
    Write-Host "zkcli path is $zkcli"

    Write-Host "Downloading existing configset $SolrConfigName"
    
    & $zkcli -zkhost solr:9983 -cmd downconfig -confdir "c:/$($SolrConfigName)" -confname "$($SolrConfigName)"
    
    Copy-Item -Force -Recurse -Verbose "$SolrConfigDir\*" -Destination "c:\$($SolrConfigName)"
    
    Write-Host "Uploading updated configset $SolrConfigName"
    
    & $zkcli -zkhost solr:9983 -cmd upconfig -confdir "c:/$($SolrConfigName)" -confname "$($SolrConfigName)"
}
else {
    # if there is no such configset it is considered that configset should be created (configset should be complete then)
    Write-Host "Compress '$SolrConfigName' SOLR config set"
    $solrConfigZipPath = Compress-7zip -Path "$SolrConfigDir\*" -DestinationPath "C:\temp\$SolrConfigName.zip"
    Write-Host "Upload '$SolrConfigName' SOLR config set"
    $solrPostConfigUrl = "$SolrEndpoint/admin/configs?action=UPLOAD&name=$SolrConfigName&overwrite=true"
    $null = Invoke-RestMethod -Uri $solrPostConfigUrl -Credential (Get-SolrCredential) -Infile $solrConfigZipPath -Method Post -ContentType "application/octet-stream"

}