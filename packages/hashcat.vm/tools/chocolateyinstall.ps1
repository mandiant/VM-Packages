$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking


$toolName = 'hashcat'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/hashcat/hashcat/releases/download/v7.1.2/hashcat-7.1.2.7z'
$zipSha256 = '80db0316387794ce9d14ed376da75b8a7742972485b45db790f5f8260307ff98'
$zipName = 'hashcat-7.1.2'
$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} "$toolName"
$workingDir = Join-Path "$toolDir" "$zipname"

try {
    # Download the zip file
    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        url           = $zipUrl
        checksum      = $zipSha256
        checksumType  = "sha256"
        fileFullPath  = Join-Path "${Env:USERPROFILE}\AppData\Local\Temp" ("$zipName.7z")
    }
    Get-ChocolateyWebFile @packageArgs
    $zipPath = $packageArgs.fileFullPath
    VM-Assert-Path $zipPath

    7z x $zipPath -o"$toolDir" -y
    # Create a shortcut
    $executablePath = Join-Path "$workingDir" "$toolName.exe" -Resolve
    VM-Install-Shortcut $toolName $category $executablePath -consoleApp $true -executableDir $workingDir
} catch {
    VM-Write-Log-Exception $_
}
