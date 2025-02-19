$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'VSCode'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executablePath = Join-Path ${Env:ProgramFiles} "\Microsoft VS Code\Code.exe" -Resolve
  VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath -runAsAdmin
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}
