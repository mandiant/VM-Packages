$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'WinDbg'
    $category = 'Debuggers'

    # It seems WinDbg is now distributed as an .appinstaller and we need to install it using Add-AppxPackage
    Add-AppxPackage -AppInstallerFile 'https://windbg.download.prss.microsoft.com/dbazure/prod/1-0-0/windbg.appinstaller'

    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $shortcut = Join-Path $shortcutDir "$toolName.lnk"
    $executableCmd  = Join-Path ${Env:WinDir} "system32\cmd.exe"
    # Use `start` to close the open console
    $executableArgs = "/C start WinDbgX.exe"
    $executableDir  = Join-Path ${Env:UserProfile} "Desktop"
    Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executableCmd -Arguments $executableArgs -WorkingDirectory $executableDir -RunAsAdmin
} catch {
    VM-Write-Log-Exception $_
}

