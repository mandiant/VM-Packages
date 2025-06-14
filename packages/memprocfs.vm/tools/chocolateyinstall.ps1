$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MemProcFS'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
# Get latest version from GitHub releases with a curl equivalent in powershell
$latestFileName = 'MemProcFS_files_and_binaries-win_x64-latest.zip'
$latestVersionUrl = 'https://api.github.com/repos/ufrisk/MemProcFS/releases/latest'

if (-not (Get-Command Invoke-RestMethod -ErrorAction SilentlyContinue)) {
    Write-Error "Invoke-RestMethod is not available. Please ensure you are running PowerShell 3.0 or later."
    $latestVersionResponse = (Invoke-WebRequest -Uri $latestVersionUrl -Headers @{ 'User-Agent' = 'VM-Installer').content | ConvertFrom-Json
}else {
    $latestVersionResponse = Invoke-RestMethod -Uri $latestVersionUrl -Headers @{ 'User-Agent' = 'VM-Installer' }
}

$latestVersion = $latestVersionResponse.tag_name

# Get the latest version's SHA256 from the assets searching in the array by the name key and getting the digest
$latestAsset = $latestVersionResponse.assets | Where-Object { $_.name -eq $latestFileName }
if (-not $latestAsset) {
    Write-Error "Latest asset not found for $latestFileName in the latest release."
    VM-Write-Log-Exception $_
    return
}
$latestAssetUrl = $latestAsset.browser_download_url
$latestAssetSha256 = $latestAsset.digest -replace '^sha256:', ''

if (-not $latestAssetSha256) {
    Write-Error "SHA256 not found for the latest asset $latestFileName."
    VM-Write-Log-Exception $_
    return
}

# Prepare the download URL and SHA256 for the zip file
if (-not $latestAssetUrl) {
    Write-Error "Download URL not found for the latest asset $latestFileName."
    VM-Write-Log-Exception $_
    return
}

$zipUrl = $latestAssetUrl
$zipSha256 = $latestAssetSha256

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
