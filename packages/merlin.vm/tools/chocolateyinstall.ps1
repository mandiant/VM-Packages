$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Merlin'
$category = 'Command & Control'
$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

$zipUrl = 'https://github.com/Ne0nd0g/merlin/releases/download/v2.1.1/merlinServer-Windows-x64.7z'
$zipSha256 = 'c6a6962505340ea92aa417452288e2b469e6a1ed757e82328a538656d3ef511f'
$zipPassword = 'merlin'
$fileName = 'merlinServer-Windows-x64'

try {
    # Download the zip file
    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        url           = $zipUrl
        checksum      = $zipSha256
        checksumType  = "sha256"
        fileFullPath  = Join-Path "${Env:USERPROFILE}\AppData\Local\Temp" ("$fileName.7z")
    }
    Get-ChocolateyWebFile @packageArgs
    $zipPath = $packageArgs.fileFullPath
    VM-Assert-Path $zipPath

    # Unzip with a password
    7z x -p"$zipPassword" "$zipPath" -o"$toolDir" -y

    # Create a shortcut
    $executablePath = Join-Path ${Env:RAW_TOOLS_DIR} "Merlin\$fileName.exe" -Resolve
    VM-Install-Shortcut $toolName $category $executablePath
} catch {
    VM-Write-Log-Exception $_
}
