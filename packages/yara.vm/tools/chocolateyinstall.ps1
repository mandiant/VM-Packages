$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $category = 'Forensic'
    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $shimPath = Join-Path ${Env:ChocolateyInstall} "bin" -Resolve
    $toolPaths = Get-ChildItem $shimPath | Where-Object { $_.Name -match '^yarac?(32|64)\.exe$' }

    foreach ($toolPath in $toolPaths) {
        $toolName = $toolPath.Name -replace ([regex]::match($toolPath.Name, '(32|64)\.exe')), ''
        $shortcut = Join-Path $shortcutDir "$toolName.lnk"
        Install-BinFile -Name $toolName -Path $toolPath

        $executablePath = $toolPath
        $executableCmd  = Join-Path ${Env:WinDir} "system32\cmd.exe"
        $executableDir  = Join-Path ${Env:UserProfile} "Desktop"
        $executableArgs = "/K `"cd `"$executableDir`" && `"$executablePath`""
        Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executableCmd -Arguments $executableArgs -WorkingDirectory $executableDir
        VM-Assert-Path $shortcut
    }
} catch {
    VM-Write-Log-Exception $_
}
