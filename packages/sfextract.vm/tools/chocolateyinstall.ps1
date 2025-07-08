$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'sfextract'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

dotnet tool update --global sfextract --version 2.1.0

$executablePath = Join-Path "${Env:UserProfile}\.dotnet\tools" "$toolName.exe" -Resolve
VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath -consoleApp $true
