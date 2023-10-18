$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {

    $installDir    = Join-Path ${Env:ProgramFiles} "ScyllaHide"
    $installUrl    = "https://github.com/x64dbg/ScyllaHide/releases/download/v1.4/ScyllaHide_2023-03-24_13-03.zip"
    $installSha256 = "edeb0dd203fd1ef38e1404e8a1bd001e05c50b6096e49533f546d13ffdcb7404"
    $packageArgs   =
    @{
        packageName    = ${Env:ChocolateyPackageName}
        unzipLocation  = $installDir
        url            = $installUrl
        checksum       = $installSha256
        checksumType   = 'sha256'
    }
    Install-ChocolateyZipPackage @packageArgs

    $pluginsDir = Join-Path ${Env:ProgramFiles} "IDA Freeware 8.3\plugins" -Resolve
    $pluginPath = Join-Path $installDir         "IDA\HookLibraryx64.dll"   -Resolve
    $configPath = Join-Path $installDir         "IDA\scylla_hide.ini"      -Resolve

    Copy-Item $pluginPath -Destination $pluginsDir
    Copy-Item $configPath -Destination $pluginsDir

} catch {
  VM-Write-Log-Exception $_
}