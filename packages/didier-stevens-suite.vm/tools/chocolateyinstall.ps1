$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $category = 'PDF'
    $zipUrl = 'https://github.com/DidierStevens/DidierStevensSuite/archive/8190354314d6f42c9ddc477a795029dc446176c5.zip'
    $zipSha256 = 'fe37ef5b81810af99820a7360aa26e7fec669432875dd29e38f307880bb53c37'

    $packageArgs = @{
        packageName    = ${Env:ChocolateyPackageName}
        unzipLocation  = ${Env:RAW_TOOLS_DIR}
        url            = $zipUrl
        checksum       = $zipSha256
        checksumType   = 'sha256'
    }
    Install-ChocolateyZipPackage @packageArgs
    $toolDir = Get-Item "${Env:RAW_TOOLS_DIR}\DidierStevensSuite-*"
    VM-Assert-Path $toolDir

    # Add shortcut for commonly used PDF tools
    ForEach ($toolName in @('pdfid', 'pdf-parser')) {
      $executablePath = Join-Path $toolDir "$toolName.py"
      VM-Install-Shortcut $toolName $category $executablePath -consoleApp $true
    }
} catch {
  VM-Write-Log-Exception $_
}
