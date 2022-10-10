# Important Note

The functionality in the PS tools here have following limitations:

1. No support for aliases: if you are going to re-create index collections with aliases, the tools here should be extended
2. All the collections and collection configs configured in the `data\collections.json` and `data\configs.json` must exist otherwise script will fail (it can be extended to handle it correctly)
3. Whole Solr configset (all the files) should be stored under `data\configs\<configsetname>`. This also can be improved but requires more logic to PS scripts (download existing configset, copy with replace files, remove config set, upload updated configset etc.)