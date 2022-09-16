# escape=`

ARG BASE_IMAGE

FROM ${BASE_IMAGE}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Add custom scripts
COPY .\custom\ C:\

# Add custom entry point
ENTRYPOINT .\Start-Custom.ps1 -SitecoreSolrConnectionString $env:SITECORE_SOLR_CONNECTION_STRING -SolrCorePrefix $env:SOLR_CORE_PREFIX_NAME -SolrSitecoreConfigsetSuffixName $env:SOLR_SITECORE_CONFIGSET_SUFFIX_NAME -SolrReplicationFactor $env:SOLR_REPLICATION_FACTOR -SolrNumberOfShards $env:SOLR_NUMBER_OF_SHARDS -SolrMaxShardsPerNodes $env:SOLR_MAX_SHARDS_NUMBER_PER_NODES -SolrXdbSchemaFile .\data\schema.json -SolrCollectionsToDeploy $env:SOLR_COLLECTIONS_TO_DEPLOY