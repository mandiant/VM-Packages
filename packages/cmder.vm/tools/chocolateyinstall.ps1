$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'cmder'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName -Resolve

  #### Change default ls alias to deconflict with unxUtils package ####
  # https://github.com/cmderdev/cmder/issues/743
  $cmderaliases = Join-Path $toolDir 'config\user_aliases.cmd'
  $content = @"
;= @echo off
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;= Add aliases below here
e.=explorer .
gl=git log --oneline --all --graph --decorate  $*
pwd=cd
clear=cls
history=cat "%CMDER_ROOT%\config\.history"
unalias=alias /d `$1
vi=vim $*
cmderr=cd /d "%CMDER_ROOT%"
"@
  Remove-Item $cmderaliases -ea 0 | Out-Null
  New-Item -ItemType File -Path $cmderaliases -Force | Out-Null
  Set-Content -Path $cmderaliases -Value $content

  $executablePath = Join-Path $toolDir 'cmder.exe' -Resolve

  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}
