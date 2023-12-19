$ErrorActionPreference = 'Continue'

$toolDir = Join-Path ${Env:ProgramFiles} "Notepad++\plugins\XMLTools"
Remove-Item $toolDir -Recurse -Force -ea 0
