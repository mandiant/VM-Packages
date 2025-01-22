$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Dokan'

$exeUrl = 'https://github.com/dokan-dev/dokany/releases/download/v2.2.1.1000/Dokan_x64.msi'
$exeSha256 = '9e08fdff1ec014b1a2478561951d6647905e9d2980248ef1868e166560556658'

$fileType = 'MSI'
$silentArgs = '/qn /norestart'
$validExitCodes= @(0, 3010, 1603, 1605, 1614, 1641)

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
        validExitCodes= $validExitCodes
        softwareName  = $toolName
    }
    Install-ChocolateyInstallPackage @packageArgs
    VM-Assert-Path $installedPath
} catch {
    VM-Write-Log-Exception $_
}
