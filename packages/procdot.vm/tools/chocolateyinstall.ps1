$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'procdot'
$category = 'Utilities'
$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

$zipUrl = 'https://procdot.com/download/procdot/binaries/procdot_1_22_57_windows.zip'
$zipSha256 = '927cd36dbb4dc0be94afb6021ca7f747dd3f17aad383583bc71aa6e36a762849'
$zipPassword = "procdot"
$zipPath = Join-Path ${Env:RAW_TOOLS_DIR} "procdot_1_22_57_windows.zip"

try {
    # Remove files from previous zips for upgrade
    VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

    # Download and unzip
    $packageArgs = @{
        packageName    = ${Env:ChocolateyPackageName}
        url            = $zipUrl
        checksum       = $zipSha256
        checksumType   = 'sha256'
        url64bit       = $zipUrl
        checksum64     = $zipSha256
        fileFullPath   = $zipPath
    }
    Get-ChocolateyWebFile @packageArgs
    VM-Assert-Path $zipPath

    # Unzip with a password
    7z x -p"$zipPassword" "$zipPath" -o"$toolDir" -y

    # Create a shortcut and set config path to required executables.
    $graphvizPath = Join-Path ${env:ProgramFiles} "Graphviz\bin\dot.exe"
    if ($env:PROCESSOR_ARCHITECTURE -eq "x86") {
        $executablePath = Join-Path ${Env:RAW_TOOLS_DIR} "$toolName\win32\$toolName.exe" -Resolve
        $windumpPath = Join-Path ${Env:RAW_TOOLS_DIR} "\WinDump\x32\WinDump.exe" -Resolve
    } else {
        $executablePath = Join-Path ${Env:RAW_TOOLS_DIR} "$toolName\win64\$toolName.exe" -Resolve
        $windumpPath = Join-Path ${Env:RAW_TOOLS_DIR} "\WinDump\x64\WinDump.exe" -Resolve
    }
    VM-Install-Shortcut $toolName $category $executablePath
} catch {
    VM-Write-Log-Exception $_
}

# Try to set configuration, but do not fail the package if it fails.
$ErrorActionPreference = 'Continue'

# Create the directory and config files only if previous config does not exist.
if (-Not (Test-Path "$home\.procdot")) {
    New-Item -ItemType Directory -Path "$home\.procdot" | Out-Null

    # Construct the content with variables
    $contentLines = @("auto_update_check = 0",
    "update_check_betas = 0",
    "windumpexecutable = $windumpPath",
    "dotexecutable = $graphvizPath")
    $content = ($contentLines -join "`n")

    # Write the content to the file
    New-Item -ItemType File -Path "$home\.procdot\.procdot" -Value $content -Force
    New-Item -ItemType File -Path "$home\.procdot\default.pd" -Force
}
