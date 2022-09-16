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

Write-Host "Compress '$SolrConfigName' SOLR config set"
$solrConfigZipPath = Compress-7zip -Path "$SolrConfigDir\*" -DestinationPath "C:\temp\$SolrConfigName.zip"
Write-Host "Upload '$SolrConfigName' SOLR config set"
$solrPostConfigUrl = "$SolrEndpoint/admin/configs?action=UPLOAD&name=$SolrConfigName&overwrite=true"
$null = Invoke-RestMethod -Uri $solrPostConfigUrl -Credential (Get-SolrCredential) -Infile $solrConfigZipPath -Method Post -ContentType "application/octet-stream"