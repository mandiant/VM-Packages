$ErrorActionPreference = 'Stop'
$name = "Mimikatz"
$path = Join-Path ${Env:TOOL_LIST_DIR} 'Password Attacks'

$toolsDir = Join-Path "${Env:RAW_TOOLS_DIR}" $name
Remove-Item -Path $toolsDir -ErrorAction SilentlyContinue -Recurse -Force

$shortcut = Join-Path $path "mimikatz.x86.lnk"
Remove-Item -Force $shortcut
Uninstall-BinFile -Name "mimikatz.x86"


$shortcut = Join-Path $path "mimikatz.x64.lnk"
Remove-Item -Force $shortcut
Uninstall-BinFile -Name "mimikatz.x64"