$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

#VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true

try {
    $toolName = 'GarbageMan'
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

    $zipUrl = 'https://github.com/WithSecureLabs/GarbageMan/releases/download/v0.2.4/GarbageMan-0.2.4.zip'
    $zipSha256 = '84007e73a21c491e9517ff70955fc8ff02b0a4a0d562d3e21521b6169b21004e'

    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
    $unzipLocation = $toolDir
    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

    $innerFolder = $true

    # Remove files from previous zips for upgrade
    VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

    $oldDirList = @()
    if (Test-Path $toolDir) {
        $oldDirList = @(Get-ChildItem $toolDir | Where-Object {$_.PSIsContainer})
    }

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

    # Diff and find new folders in $toolDir
    $newDirList = @(Get-ChildItem $toolDir | Where-Object {$_.PSIsContainer})
    $diffDirs = Compare-Object -ReferenceObject $oldDirList -DifferenceObject $newDirList -PassThru

    # If $innerFolder is set to $true, after unzipping only a single folder should be new.
    # GitHub ZIP files typically unzip to a single folder that contains the tools.
    if ($innerFolder) {
        # First time install, use the single resulting folder name from Install-ChocolateyZipPackage.
        if ($diffDirs.Count -eq 1) {
            # Save the "new tool directory" to assist with upgrading.
            $newToolDir = Join-Path $toolDir $diffDirs[0].Name -Resolve
            Set-Content (Join-Path ${Env:chocolateyPackageFolder} "innerFolder.txt") $newToolDir
            $toolDir = $newToolDir
        } else {
            # On upgrade there may be no new directory, in this case retrieve previous "new tool directory" from saved file.
            $toolDir = Get-Content (Join-Path ${Env:chocolateyPackageFolder} "innerFolder.txt")
        }
    }

    $executablePath = Join-Path $toolDir "$toolName.exe" -Resolve
    $shortcut = Join-Path $shortcutDir "$toolName.lnk"

    $executableDir  = $toolDir
    Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -WorkingDirectory $executableDir
    VM-Assert-Path $shortcut

    return $executablePath
} catch {
    VM-Write-Log-Exception $_
}