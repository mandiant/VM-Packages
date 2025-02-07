$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$pluginUrl = "https://github.com/KasperskyLab/hrtng/releases/download/v2.2.21/hrtng-2.2.21.7z"
$pluginSha256 = "0918639f3a27fe2d85556cd7a730fc588456302f2e95a23e9e3f62f4e17b0f1e"
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
