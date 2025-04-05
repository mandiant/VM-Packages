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
  $toolSource = 'https://github.com/iBotPeaches/Apktool/releases/download/v2.11.1/apktool_2.11.1.jar'
  $toolChecksum = "56d59c524fc764263ba8d345754d8daf55b1887818b15cd3b594f555d249e2db"
  Get-ChocolateyWebFile -PackageName $toolName -FileFullPath $toolPath -Url $toolSource -Checksum $toolChecksum -ChecksumType "sha256"
  VM-Assert-Path $toolPath

  # Add apktool to Path
  VM-Add-To-Path $rawToolPath

  VM-Install-Shortcut -toolname $toolname -category $category -executablePath $wrapperPath -consoleApp $true
} catch {
  VM-Write-Log-Exception $_
}
