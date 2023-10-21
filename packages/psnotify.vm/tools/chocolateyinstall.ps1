$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'psnotify'
    $category = 'dotNet'

    $zipUrl = 'https://github.com/WithSecureLabs/GarbageMan/releases/download/v0.2.4/psnotify.zip'
    $zipSha256 = '255633da6e61bf30a67bce995ef72b7f9d8c85c75c8c5ee0aedb48709f7e6454'

    $unzipLocation = 'C:\'  # psnotify has a requirement of being located in 'C:\psnotify'
    $toolDir = Join-Path $unzipLocation $toolName
    try {
        $toolDir = Join-Path $unzipLocation $toolName
        $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

        # Remove files from previous zips for upgrade
        VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

        # Download and unzip
        $packageArgs = @{
            packageName    = ${Env:ChocolateyPackageName}
            unzipLocation  = $unzipLocation
            url            = $zipUrl
            checksum       = $zipSha256
            checksumType   = 'sha256'
            url64bit       = $zipUrl_64
            checksum64     = $zipSha256_64
        }
        Install-ChocolateyZipPackage @packageArgs
        VM-Assert-Path $toolDir
        $executablePath = Join-Path $toolDir "$toolName.exe" -Resolve
        $shortcut = Join-Path $shortcutDir "$toolName.lnk"

        $executableDir  = $toolDir
        Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -WorkingDirectory $executableDir
        VM-Assert-Path $shortcut

        Install-BinFile -Name $toolName -Path $executablePath
        return $executablePath
    } catch {
        VM-Write-Log-Exception $_
    }
    VM-Assert-Path $toolDir
} catch {
    VM-Write-Log-Exception $_
}