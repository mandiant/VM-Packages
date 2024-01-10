$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Dokan'

$exeUrl = 'https://github.com/dokan-dev/dokany/releases/download/v2.0.6.1000/Dokan_x64.msi'
$exeSha256 = '1de58167e28d0c4be6af17abfe5ce9d8dc0bff032f900b225e23b79147b0fff2'

$fileType = 'MSI'
$silentArgs = '/qn /norestart'

try {
    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
    $installedPath = Join-Path ${Env:ProgramFiles} $toolName
    $installerName = Split-Path -Path $exeUrl -Leaf
    $installerPath = Join-Path $toolDir $installerName


    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        fileFullPath  = $installerPath
        url           = $exeUrl
        checksum      = $exeSha256
        checksumType  = "sha256"
    }

    Get-ChocolateyWebFile @packageArgs
    VM-Assert-Path $installerPath

    # Install tool via native installer
    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        fileType      = $fileType
        file          = $installerPath
        silentArgs    = $silentArgs
        softwareName  = $toolName
    }
    Install-ChocolateyInstallPackage @packageArgs
    VM-Assert-Path $installedPath
} catch {
    VM-Write-Log-Exception $_
}
