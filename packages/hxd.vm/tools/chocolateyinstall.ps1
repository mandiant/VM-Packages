$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'HxD'
    $category = 'Hex Editors'

    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $shortcut = Join-Path $shortcutDir "$toolName.lnk"
    $executablePath = Join-Path ${Env:ProgramFiles} "HxD\HxD.exe" -Resolve
    Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
    VM-Assert-Path $shortcut

    Install-BinFile -Name $toolName -Path $executablePath
} catch {
    VM-Write-Log-Exception $_
}

