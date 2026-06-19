$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'ilspycmd'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

  $zipUrl = 'https://api.nuget.org/v3-flatcontainer/ilspycmd/9.0.0.7889/ilspycmd.9.0.0.7889.nupkg'
  $zipSha256 = '18ccd4e4abf2e7db42693b9c7827bfa714a311fd0fe84f7e3222110079b71a56'
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
  }
  Install-ChocolateyZipPackage @packageArgs | Out-Null
  VM-Assert-Path $toolDir

  $netDir = Join-Path $toolDir 'tools\net8.0\any'
  $batPath = Join-Path $netDir 'ilspycmd.bat'
  $batContent = "@echo off`r`ndotnet `"%~dp0ilspycmd.dll`" %*"
  Set-Content -Path $batPath -Value $batContent -Encoding Ascii

  VM-Install-Shortcut -toolName $toolName -category $category -executablePath $batPath -consoleApp $true -arguments '--help' -executableDir $netDir
  Install-BinFile -Name $toolName -Path $batPath

} catch {
  VM-Write-Log-Exception $_
}
