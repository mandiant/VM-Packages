$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'Malcode Analyst Pack'
  $category = 'Utilities'

  $url = 'http://sandsprite.com/flare_vm/map_setup_7.26.23__A2A58AF886B9BF4DC6DB5CFDFF9B7E2300F0D0C491CD07DAC871DF60DAA370C4.exe'
  $checksum = 'A2A58AF886B9BF4DC6DB5CFDFF9B7E2300F0D0C491CD07DAC871DF60DAA370C4'

  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    fileType      = 'EXE'
    url           = $url
    checksum      = $checksum
    checksumType  = 'sha256'
    silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /DIR=`"$toolDir`""
  }
  Install-ChocolateyPackage @packageArgs
  VM-Assert-Path $toolDir

  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $toolDir
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}

# Try to remove right click registry keys, but do not fail the package if it fails.
$ErrorActionPreference = 'Continue'

$cmdHereRegistryPath1 = "HKLM:\SOFTWARE\Classes\Directory\background\shell\ctx_cmd"
$cmdHereRegistryPath2 = "HKLM:\SOFTWARE\Classes\Folder\shell\Cmd Here"

ForEach ($regKey in @($cmdHereRegistryPath1, $cmdHereRegistryPath2)) {
  Remove-Item -Path $regKey -Recurse -Force
}
