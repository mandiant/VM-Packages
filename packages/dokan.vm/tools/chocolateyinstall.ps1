$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Dokan'

$exeUrl = 'https://github.com/dokan-dev/dokany/releases/download/v2.1.0.1000/Dokan_x64.msi'
$exeSha256 = '930b596d6cd7a8f3508f39bd4eab8c2f178178d39d11a9e135180b69820df47f'

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
