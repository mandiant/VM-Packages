$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'scdbg'
    $category = 'Debuggers'

    $zipUrl = 'https://github.com/dzzie/VS_LIBEMU/releases/download/12.7.22/VS_LIBEMU_12_7_22.zip'
    $zipSha256 = '521130E34CC0A30587FF99D030633B9D124CCAC779A213E15025535171B4113D'

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

