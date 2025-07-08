$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    # The way of distributing this tool is unusual, so we can't use the helper functions
    $toolName = 'idr'
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

    $zipUrl = 'https://github.com/crypto2011/IDR/archive/da98ef6871b75303bcf1a5acc692e38178c7833e.zip'
    $zipSha256 = 'ea779489a868deb811e403398ec3c1b65484f60811f5fff95a0ae42563b68caf'

    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

    # Create a temp directory to download zip
    $tempDownloadDir = Join-Path ${Env:chocolateyPackageFolder} "temp_$([guid]::NewGuid())"

    # Download and unzip
    $packageArgs = @{
        packageName    = ${Env:ChocolateyPackageName}
        unzipLocation  = $tempDownloadDir
        url            = $zipUrl
        checksum       = $zipSha256
        checksumType   = 'sha256'
    }
    Install-ChocolateyZipPackage @packageArgs | Out-Null
    VM-Assert-Path $tempDownloadDir

    # Get the unzipped directory
    $unzippedDir = (Get-ChildItem -Directory $tempDownloadDir | Where-Object {$_.PSIsContainer} | Select-Object -f 1).FullName

    # Create tool directory and copy needed files to it
    New-Item -Path $toolDir -ItemType Directory -Force | Out-Null
    Move-Item "$unzippedDir\bin\idr.exe" $toolDir -Force
    Move-Item "$unzippedDir\bin\dis.dll" $toolDir -Force
    Move-Item "$unzippedDir\bin\Icons.dll" $toolDir -Force
    Move-Item "$unzippedDir\*.bin" $toolDir -Force
    # Copy all knowledge bases
    $zippedBases = Get-ChildItem -Path $unzippedDir -Recurse -Filter "kb*.7z" | ForEach-Object { $_.FullName }
    foreach ($zippedBase in $zippedBases) {
      Get-ChocolateyUnzip -FileFullPath $zippedBase -Destination $toolDir
    }

    # Attempt to remove temporary directory
    Remove-Item $tempDownloadDir -Recurse -Force -ea 0

    $executablePath = Join-Path $toolDir "$toolName.exe" -Resolve
    VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath
} catch {
    VM-Write-Log-Exception $_
}

