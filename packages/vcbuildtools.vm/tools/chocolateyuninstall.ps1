﻿$ErrorActionPreference = 'Continue'
$shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} 'Utilities'
$shortcut = Join-Path $shortcutDir 'Microsoft Visual C++ Build Tools.lnk'
Remove-Item $shortcut -Force -ea 0 | Out-Null
