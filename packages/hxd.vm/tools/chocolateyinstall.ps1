$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'HxD'
    $category = 'Hex Editors'

    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $shortcut = Join-Path $shortcutDir "$toolName.lnk"
    $executablePath = Join-Path ${Env:ProgramFiles} "HxD\HxD.exe" -Resolve
    Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath
    VM-Assert-Path $shortcut

    Install-BinFile -Name $toolName -Path $executablePath

    VM-Add-To-Right-Click-Menu $toolName $toolName "`"$executablePath`" `"%1`"" "file" "$executablePath"
} catch {
    VM-Write-Log-Exception $_
}

