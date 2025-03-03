$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$pluginUrl = "https://github.com/KasperskyLab/hrtng/releases/download/v2.3.25/hrtng-2.3.25.7z"
$pluginSha256 = "4dc76bf461db3c1cd043d84c7a0a542a837a02d6e01ec3c69fd25c100afd265c"
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
