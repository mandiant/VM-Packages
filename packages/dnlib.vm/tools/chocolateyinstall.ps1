$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'dnlib'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

  $zipUrl = 'https://www.nuget.org/api/v2/package/dnlib/4.0.0'
  $zipSha256 = 'adee956696461c9146da3ba220a1a3e6f553a8ba26f2664b1d8507a35976961e'
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

  # Download and unzip
  $packageArgs = @{
      packageName    = ${Env:ChocolateyPackageName}
      unzipLocation  = $toolDir
      url            = $zipUrl
      checksum       = $zipSha256
      checksumType   = 'sha256'
      SpecificFolder = "lib"
  }
  Install-ChocolateyZipPackage @packageArgs
  VM-Assert-Path $toolDir

  $executablePath = Join-Path $toolDir "lib"
  VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath

} catch {
  VM-Write-Log-Exception $_
}
