$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'apktool'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)
  $rawToolPath = Join-Path ${Env:RAW_TOOLS_DIR} "$toolName"

  # Download apktool.bat
  $wrapperPath = Join-Path $rawToolPath "$toolName.bat"
  $wrapperSource = 'https://raw.githubusercontent.com/iBotPeaches/Apktool/0741664808724bda41744ad3981bac2eec672d1b/scripts/windows/apktool.bat'
  $wrapperChecksum = "3e1c29f9d2c7b3a7c938573f4c2ae61172f6221dc9febfa85080f354357d6336"
  Get-ChocolateyWebFile -PackageName '$toolName wrapper script' -FileFullPath $wrapperPath -Url $wrapperSource -Checksum $wrapperChecksum -ChecksumType "sha256"
  VM-Assert-Path $wrapperPath

  # Download apktool.jar
  $toolPath = Join-Path $rawToolPath "$toolName.jar"
  $toolSource = 'https://github.com/iBotPeaches/Apktool/releases/download/v2.12.0/apktool_2.12.0.jar'
  $toolChecksum = "effb69dab2f93806cafc0d232f6be32c2551b8d51c67650f575e46c016908fdd"
  Get-ChocolateyWebFile -PackageName $toolName -FileFullPath $toolPath -Url $toolSource -Checksum $toolChecksum -ChecksumType "sha256"
  VM-Assert-Path $toolPath

  # Add apktool to Path
  VM-Add-To-Path $rawToolPath

  VM-Install-Shortcut -toolname $toolname -category $category -executablePath $wrapperPath -consoleApp $true
} catch {
  VM-Write-Log-Exception $_
}
