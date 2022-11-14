param(
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$ResourcesDirectory,
    [Parameter(Mandatory)][string]$SqlServer,
    [Parameter(Mandatory)][string]$SqlAdminUser,
    [Parameter(Mandatory)][string]$SqlAdminPassword,
    [string]$SqlElasticPoolName
)

$shardDeploymentToolConnectionString = "Server=$($SqlServer);User ID=$($SqlAdminUser);Password=$($SqlAdminPassword)"
$dbShardMapManager = "Sitecore.Xdb.Collection.ShardMapManager"
$dbedition = "Standard"
$shardnumber = "2"
$shardNamePrefix = "Sitecore.Xdb.Collection.Shard"
$dacPacPath = (Join-Path $ResourcesDirectory "Sitecore.Xdb.Collection.Database.Sql.dacpac")
$shardToolExe = (Join-Path $ResourcesDirectory "collectiondeployment\Sitecore.Xdb.Collection.Database.SqlShardingDeploymentTool.exe")

$shardDeploymentToolCommand = " /operation 'create' /connectionstring '$ShardDeploymentToolConnectionString' /shardMapManagerDatabaseName '$dbShardMapManager' /shardnumber '$shardnumber' /shardnameprefix '$shardNamePrefix' /dacpac '$dacPacPath'"

if($SqlElasticPoolName) {
    $shardDeploymentToolCommand += " /elasticpool '$SqlElasticPoolName'"
}else{
    $shardDeploymentToolCommand += " /dbedition '$dbedition'"
}

Invoke-Expression "& $shardToolExe $shardDeploymentToolCommand"