$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = "pd"
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'Process-Dump'
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

  $url = 'https://github.com/glmcdona/Process-Dump/releases/download/v3.0.0/pd32.exe'
  $checksum = '1f6cff215c710e241f69d11300171a5b43c084103fe9b75dbf1bcfc47e8336de'

  $executablePath = Join-Path $toolDir ($toolName + "32.exe")
  $packageArgs = @{
    packageName = ${Env:ChocolateyPackageName}
    url = $url
    checksum = $checksum
    checksumType = "sha256"
    fileFullPath = $executablePath
    forceDownload = $true
  }
  Get-ChocolateyWebFile @packageArgs
  VM-Assert-Path $executablePath

  $executableCmd  = Join-Path ${Env:WinDir} "system32\cmd.exe" -Resolve
  $executableDir  = Join-Path ${Env:UserProfile} "Desktop" -Resolve
  $executableArgs = "/K `"cd `"$executableDir`" && `"$executablePath`" --help`""
  $shortcut = Join-Path $shortcutDir ($toolName + "32.lnk")
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executableCmd -Arguments $executableArgs -WorkingDirectory $executableDir -RunAsAdmin
  VM-Assert-Path $shortcut
  Install-BinFile -Name ($toolName + "32") -Path $executablePath

  if (Get-OSArchitectureWidth -Compare 64) {
    $url = 'https://github.com/glmcdona/Process-Dump/releases/download/v3.0.0/pd64.exe'
    $checksum = '5bb74f6bf8d7d54280031fa0b479a6f3822cd52bc87c1417b3f2b40224215507'

    $executablePath = Join-Path $toolDir ($toolName + "64.exe")
    $packageArgs = @{
      packageName = ${Env:ChocolateyPackageName}
      url64bit = $url
      checksum64 = $checksum
      checksumType = "sha256"
      fileFullPath = $executablePath
      forceDownload = $true
    }
    Get-ChocolateyWebFile @packageArgs
    VM-Assert-Path $executablePath

    $executableArgs = "/K `"cd `"$executableDir`" && `"$executablePath`" --help`""
    $shortcut = Join-Path $shortcutDir ($toolName + "64.lnk")
    Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executableCmd -Arguments $executableArgs -WorkingDirectory $executableDir -RunAsAdmin
    VM-Assert-Path $shortcut
    Install-BinFile -Name ($toolName + "64") -Path $executablePath
  }
} catch {
  VM-Write-Log-Exception $_
}
