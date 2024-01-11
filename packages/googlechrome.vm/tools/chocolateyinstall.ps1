$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    # Download the installer
    $packageArgs        = @{
        packageName     = $env:ChocolateyPackageName
        file            = Join-Path ${Env:TEMP} 'googlechromeinstaller.msi'
        url             = 'https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise.msi'
        url64bit        = 'https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi'
    }
    $filePath = Get-ChocolateyWebFile @packageArgs
    VM-Assert-Path $filePath
    VM-Assert-Signature $filePath

    # Install the downloaded installer
    $packageArgs        = @{
        packageName     = $env:ChocolateyPackageName
        file            = $filePath
        fileType        = 'MSI'
        silentArgs      = "/quiet /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
    }
    Install-ChocolateyInstallPackage @packageArgs
} catch {
    VM-Write-Log-Exception $_
}
