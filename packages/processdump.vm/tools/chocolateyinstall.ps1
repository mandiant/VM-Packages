$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = "pd"
  $category = "Utilities"

  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'Process-Dump'
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

  $url = 'https://github.com/glmcdona/Process-Dump/releases/download/v2.1.1/pd32.exe'
  $checksum = 'c5d3535d33797a3b62916f5ea16b8710a0f5a7ce79ca4b2920eab245d99980d1'

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
    $url = 'https://github.com/glmcdona/Process-Dump/releases/download/v2.1.1/pd64.exe'
    $checksum = 'f2c2d46331ddf2a4982ada7f3f2ea3a0946b99204d172b68d7bd6301eac5bb95'

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
