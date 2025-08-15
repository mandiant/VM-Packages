$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'WinDump'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/hsluoyz/WinDump/releases/download/v0.3/WinDump-for-Npcap-0.3.zip'
$zipSha256 = '7ed45fb06c8c9731ef095db627eaca23b445b2809041e164996121e49b24f5d4'

try {
    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

    # Remove files from previous zips for upgrade
    VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

    # Download and unzip
    $packageArgs = @{
        packageName    = ${Env:ChocolateyPackageName}
        unzipLocation  = $toolDir
        url            = $zipUrl
        checksum       = $zipSha256
        checksumType   = 'sha256'
        url64bit       = $zipUrl
        checksum64     = $zipSha256
    }
    Install-ChocolateyZipPackage @packageArgs
    VM-Assert-Path $toolDir

    if ($env:PROCESSOR_ARCHITECTURE -eq "x86") {
        $executablePath = Join-Path $toolDir "\x86\$toolName.exe" -Resolve
    } else {
        $executablePath = Join-Path $toolDir "\x64\$toolName.exe" -Resolve
    }

    VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath
    Install-BinFile -Name $toolName -Path $executablePath
} catch {
    VM-Write-Log-Exception $_
}
