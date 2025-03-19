$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$pluginUrl = "https://github.com/KasperskyLab/hrtng/releases/download/v2.4.30/hrtng-2.4.30.7z"
$pluginSha256 = "34ca57eb236cda6fc46983748e58a4dc3efcfb020107b923416e0d1549905f67"
$tempDownloadDir = Join-Path ${Env:TEMP} "temp_$([guid]::NewGuid())"

$packageArgs = @{
    packageName    = ${Env:ChocolateyPackageName}
    unzipLocation  = $tempDownloadDir
    url            = $pluginUrl
    checksum       = $pluginSha256
    checksumType   = 'sha256'
}
Install-ChocolateyZipPackage @packageArgs | Out-Null
VM-Assert-Path $tempDownloadDir

$pluginsDir = VM-Get-IDA-Plugins-Dir
$pluginFileNames = @("windows\9.0\hrtng.dll", "apilist.txt", "literal.txt")
ForEach ($pluginFileName in $pluginFileNames) {
  $pluginFile = Join-Path $tempDownloadDir "plugins\$pluginFileName" -Resolve
  Copy-Item $pluginFile $pluginsDir
}

Remove-Item $tempDownloadDir -Recurse -Force -ea 0 | Out-Null
