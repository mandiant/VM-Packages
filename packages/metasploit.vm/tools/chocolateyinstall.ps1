$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    # Download the installer
    $packageArgs        = @{
        packageName     = $env:ChocolateyPackageName
        file            = Join-Path ${Env:TEMP} 'metasploitframework-latest.msi'
        url             = 'https://windows.metasploit.com/metasploitframework-latest.msi'
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