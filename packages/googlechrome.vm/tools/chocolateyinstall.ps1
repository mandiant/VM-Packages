$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$fileType = "MSI"
$silentArgs = "/quiet /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
$validExitCodes = @(0, 3010, 1603, 1605, 1614, 1641)

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
    $packageArgs = @{
        packageName    = $env:ChocolateyPackageName
        file           = $filePath
        fileType       = $fileType
        silentArgs     = $silentArgs
        validExitCodes = $validExitCodes
    }
    Install-ChocolateyInstallPackage @packageArgs -ErrorAction SilentlyContinue

    $exePath = "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe"
    VM-Assert-Path $exePath
} catch {
    VM-Write-Log-Exception $_
}

# Try to set configuration, but do not fail the package if it fails
$ErrorActionPreference = 'Continue'

VM-Remove-Desktop-Shortcut "Google Chrome"

# Expand the path to the Chrome User Data folder and create the "User Data" folder if it doesn't exist.
$userDataPath = ${Env:LOCALAPPDATA} + "\Google\Chrome\User Data"
New-Item -ItemType Directory -Path $userDataPath -Force -ea 0 | Out-Null

# Create the empty file "First Run" to bypass the "Sign in to Chrome" initial pop-up.
New-Item -Path $userDataPath -Name "First Run" -ItemType File -Force -ea 0 | Out-Null

# Create the "Local State" file with data required to bypass the "What's New" pop-up tab.
# Number must be higher than the current Chrome Version number and using 999 gives us some time before it fails.
$contentOptions = @{
    Path = Join-Path $userDataPath "Local State"
    Value = '{"browser":{"last_whats_new_version":999}}'
}
Set-Content @contentOptions

# Create the "Default" folder with a "Preferences" file with data required to bypass "Enhanced ad privacy" pop-up.
New-Item -Path $userDataPath -Name "Default" -ItemType Directory -Force -ea 0 | Out-Null
$contentOptions = @{
    Path = Join-Path $userDataPath "Default\Preferences"
    Value = "`{`"privacy_sandbox`":{`"m1`":{`"row_notice_acknowledged`":true}}`}"
}
Set-Content @contentOptions

# Remove Edge from being default for file extensions so Chrome can be the default
ForEach ($hive in @("HKCU:", "HKLM:")) {
    Remove-Item -Path "${hive}\SOFTWARE\Classes\MSEdgeHTM" -Recurse -ErrorAction SilentlyContinue
}

# Set Chrome to be the default browser
SetDefaultBrowser "chrome"

# Do not show the "Open with" popup
Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -name "NoNewAppAlert" -value 1 -type "DWord"

# Restart Explorer.exe for registry change to take effect
Stop-Process -Name explorer -Force
