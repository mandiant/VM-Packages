$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'exiftool'
    $category = 'File Information'
    $shimPath = 'bin\exiftool.exe'

    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $shortcut = Join-Path $shortcutDir "$toolName.lnk"
    $executablePath = Join-Path ${Env:ChocolateyInstall} $shimPath -Resolve
    $executableCmd  = Join-Path ${Env:WinDir} "system32\cmd.exe" -Resolve
    $executableDir  = Join-Path ${Env:UserProfile} "Desktop" -Resolve
    $executableArgs = "/K `"cd `"$executableDir`" && `"$executablePath`"`""
    Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executableCmd -Arguments $executableArgs -WorkingDirectory $executableDir -IconLocation $executablePath -RunAsAdmin
    VM-Assert-Path $shortcut
} catch {
    VM-Write-Log-Exception $_
}

