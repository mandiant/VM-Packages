$ErrorActionPreference = 'Continue'

$toolDir = Join-Path ${Env:ProgramFiles} "Notepad++\plugins\ComparePlugin"
Remove-Item $toolDir -Recurse -Force -ea 0
