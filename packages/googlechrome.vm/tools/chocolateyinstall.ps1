$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
. $toolsPath\SFTA.ps1
. $toolsPath\helpers.ps1

$downloadDir = Get-PackageCacheLocation
$installer          = 'googlechromeinstaller.msi'
$packageArgs        = @{
    packageName     = $env:ChocolateyPackageName
    file            = Join-Path $downloadDir $installer
    url             = 'https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise.msi'
    url64bit        = 'https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi'
    fileType        = 'MSI'
    silentArgs      = "/quiet /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
    validExitCodes  = @(0)
}

# Download the installer
$packageArgs['file'] = Get-ChocolateyWebFile @packageArgs

Start-Sleep 2

$sigValid = (Get-AuthenticodeSignature -FilePath $packageArgs['file']).Status -eq 'Valid'

try {
    if ($sigValid) {
        VM-Write-Log "INFO" "`tSignature valid ... installing"
        Install-ChocolateyInstallPackage @packageArgs

        VM-Write-Log "INFO" "`tSetup associations"
        Set-PTA ChromeHTML http
        Set-PTA ChromeHTML https
        Set-FTA ChromeHTML .htm
        Set-FTA ChromeHTML .html

        VM-Write-Log "INFO" "`tDisable update settings"
        Disable-Chrome-Updates
    } else {
        $file = $packageArgs['file']
        VM-Write-Log "WARN" "`tSignature for downloaded $file is not valid"
    }
} catch {
    VM-Write-Log-Exception $_
}
