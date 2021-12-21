$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = "pd"
  $category = "Utilities"

  $toolDirParent = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  $toolDir = Join-Path $toolDirParent $toolName
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $zipUrl = "http://www.split-code.com/files/pd_v2_1.zip"
  $zipSha256 = "2060f6713c082e78b2c18e6cb4e195602296af7ff9b096931f5f9f70a145b487"

  # Remove files from previous zips for upgrade
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = $zipUrl
    checksum       = $zipSha256
    checksumType   = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs

  $executablePath = Join-Path $toolDir ($toolName + "32.exe") -Resolve
  $executableCmd  = Join-Path ${Env:WinDir} "system32\cmd.exe" -Resolve
  $executableDir  = Join-Path ${Env:UserProfile} "Desktop" -Resolve
  $executableArgs = "/K `"cd ${executableDir} && $executablePath -h`""
  $shortcut = Join-Path $shortcutDir ($toolName + "32.lnk")
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executableCmd -Arguments $executableArgs -WorkingDirectory $executableDir -RunAsAdmin
  VM-Assert-Path $shortcut

  if (Get-OSArchitectureWidth -Compare 64) {
    $executablePath64 = Join-Path $toolDir ($toolName + "64.exe") -Resolve
    $executableArgs64 = "/K `"cd ${executableDir} && $executablePath64 -h`""
    $shortcut64 = Join-Path $shortcutDir ($toolName + "64.lnk")
    Install-ChocolateyShortcut -shortcutFilePath $shortcut64 -targetPath $executableCmd -Arguments $executableArgs64 -WorkingDirectory $executableDir -RunAsAdmin
    VM-Assert-Path $shortcut64
  }
} catch {
  VM-Write-Log-Exception $_
}
