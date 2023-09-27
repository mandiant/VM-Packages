$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'idafree'
  $category = 'Disassemblers'
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

  $packageArgs = @{
    packageName  = ${Env:ChocolateyPackageName}
    fileType     = 'exe'
    silentArgs   = '--mode unattended'
    url          = 'https://out7.hex-rays.com/files/idafree83_windows.exe'
    checksum     = '10080a057704630578e697c6bb0b09968a54138075cacab175f62d60c71d0a1f'
    checksumType = 'sha256'
  }
  Install-ChocolateyPackage @packageArgs

  $toolDir = Join-Path ${Env:ProgramFiles} "IDA Freeware 8.3" -Resolve
  $executablePath = Join-Path $toolDir "ida64.exe" -Resolve
  $shortcut = Join-Path $shortcutDir "$toolname.lnk"
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath
  VM-Assert-Path $shortcut

  Install-BinFile -Name $toolname -Path $executablePath

  # Delete Desktop shortcut
  $desktopShortcut = Join-Path ${Env:Public} "Desktop\IDA Freeware 8.3.lnk"
  if (Test-Path $desktopShortcut) {
    Remove-Item $desktopShortcut -Force -ea 0
  }

  $menuIcon = Join-Path $toolDir "ida.ico" -Resolve
  # Run a Powershell script to open with last IDA Pro version which is likely installed after the IDA free package.
  # It takes slightly longer than using an static path but it works after installing IDA Pro and every time you update it.
  # The "-WindowStyle hidden" still shows the Powershell Window briefly: https://github.com/PowerShell/PowerShell/issues/3028
  # We could use the run-hidden wrapper, which won't display the Window but is likely slightly slower.
  $script = "`$idaExecutable = Get-Item '$Env:programfiles\IDA Pro *\ida.exe' | Select-Object -Last 1; if (!`$idaExecutable) { `$idaExecutable = '$executablePath' }; & `$idaExecutable '%1'"
  VM-Add-To-Right-Click-Menu $toolName 'Open with IDA' "powershell.exe -WindowStyle hidden `"$script`"" "$menuIcon"
  # Repeat for x64
  $script = "`$idaExecutable = Get-Item '$Env:programfiles\IDA Pro *\ida64.exe' | Select-Object -Last 1; if (!`$idaExecutable) { `$idaExecutable = '$executablePath' }; & `$idaExecutable '%1'"
  VM-Add-To-Right-Click-Menu $toolName-64 'Open with IDA (x64)' "powershell.exe -WindowStyle hidden `"$script`"" "$executablePath"
} catch {
  VM-Write-Log-Exception $_
}
