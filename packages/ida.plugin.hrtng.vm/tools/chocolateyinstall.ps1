$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$pluginUrl = "https://github.com/KasperskyLab/hrtng/releases/download/v1.1.19/hrtng-1.1.19.7z"
$pluginSha256 = "2b7b133663f0d4d572a13239d6e541c6d5dbf05abfa64e56ba42e1c2296356f1"
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
