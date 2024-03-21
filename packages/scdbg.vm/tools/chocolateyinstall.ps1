$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'scdbg'
    $category = 'Shellcode'

    $zipUrl = 'http://sandsprite.com/flare_vm/VS_LIBEMU_7.26.23__D7A7B407A0FB2288655247FF3EDD361E767075B15D2F0554EB9C87BC4476D996.zip'
    $zipSha256 = 'D7A7B407A0FB2288655247FF3EDD361E767075B15D2F0554EB9C87BC4476D996'

    VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true

    # Add GUI variant of scdbg
    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
    $executablePath = Join-Path $toolDir 'gui_launcher.exe' -Resolve
    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $shortcut = Join-Path $shortcutDir 'scdbg_gui.lnk'
    Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath
    Install-BinFile -Name 'scdbg_gui' -Path $executablePath
} catch {
    VM-Write-Log-Exception $_
}

