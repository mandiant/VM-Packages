$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'diaphora'
$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

$pluginUrl = 'https://github.com/joxeankoret/diaphora/archive/refs/tags/3.2.1.zip'
$pluginSha256 = '5ae160e6bb1534bde8d990577390e609d7e616a869abece3ee6c73865018a54b'

# Remove files from previous zips for upgrade
VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

# Download and unzip
$packageArgs = @{
    packageName    = ${Env:ChocolateyPackageName}
    unzipLocation  = $toolDir
    url            = $pluginUrl
    checksum       = $pluginSha256
    checksumType   = 'sha256'
}
Install-ChocolateyZipPackage @packageArgs | Out-Null
VM-Assert-Path $toolDir

# There is an inner folder in the zip whose name changes as it includes the version
$dirList = Get-ChildItem $toolDir -Directory
$toolDir = Join-Path $toolDir $dirList[0].Name -Resolve

$pluginName = "diaphora_plugin.py"
$pluginsDir = VM-Get-IDA-Plugins-Dir
$pluginFile = Get-Item "$toolDir\plugin\$pluginName" -ea 0
Copy-Item "$pluginFile" "$pluginsDir"

$cfgFile = Join-Path $pluginsDir "diaphora_plugin.cfg"
"[Diaphora]`npath=$toolDir" | out-file -encoding ASCII "$cfgFile"
