$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'Malcode Analyst Pack'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

  $url = 'https://sandsprite.com/flare_vm/map_setup_4.1.25_3A212024765B7A564A380FAB29078E20FDB220F915EE60A1C9B885BFBC99905E.exe'
  $checksum = '3A212024765B7A564A380FAB29078E20FDB220F915EE60A1C9B885BFBC99905E'

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
