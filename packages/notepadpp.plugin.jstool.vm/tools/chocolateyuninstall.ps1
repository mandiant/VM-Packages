$ErrorActionPreference = 'Continue'

$toolDir = Join-Path ${Env:ProgramFiles} "Notepad++\plugins\JSMinNPP"
Remove-Item $toolDir -Recurse -Force -ea 0
