$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'apktool'
  $category = 'Java & Android'
  $rawToolPath = Join-Path ${Env:RAW_TOOLS_DIR} "$toolName"

  # Download apktool.bat
  $wrapperPath = Join-Path $rawToolPath "$toolName.bat"
  $wrapperSource = 'https://raw.githubusercontent.com/iBotPeaches/Apktool/0741664808724bda41744ad3981bac2eec672d1b/scripts/windows/apktool.bat'
  $wrapperChecksum = "3e1c29f9d2c7b3a7c938573f4c2ae61172f6221dc9febfa85080f354357d6336"
  Get-ChocolateyWebFile -PackageName '$toolName wrapper script' -FileFullPath $wrapperPath -Url $wrapperSource -Checksum $wrapperChecksum -ChecksumType "sha256"
  VM-Assert-Path $wrapperPath

  # Download apktool.jar
  $toolPath = Join-Path $rawToolPath "$toolName.jar"
  $toolSource = 'https://github.com/iBotPeaches/Apktool/releases/download/v2.11.0/apktool_2.11.0.jar'
  $toolChecksum = "8fdc17c6fe2e6d80d71b8718eb2a5d0379f1cc7139ae777f6a499ce397b26f54"
  Get-ChocolateyWebFile -PackageName $toolName -FileFullPath $toolPath -Url $toolSource -Checksum $toolChecksum -ChecksumType "sha256"
  VM-Assert-Path $toolPath

  # Add apktool to Path
  VM-Add-To-Path $rawToolPath

  VM-Install-Shortcut -toolname $toolname -category $category -executablePath $wrapperPath -consoleApp $true
} catch {
  VM-Write-Log-Exception $_
}
