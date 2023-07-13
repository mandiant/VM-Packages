$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

#vars for powersploit
$toolName = 'PowerSploit'
$category = 'Exploitation'

# install powersploit, import module, and list available powersploit modules
$zipUrl = 'https://github.com/ZeroDayLab/PowerSploit/archive/72a88240ed0c6527f3880a1fb15ea7a19589c2d8.zip'
$zipSha256 = '4a86b4b92e97fe6f1d76d8d93d9e481c007809db803cc82f4f0ec86ff7186bcf'
$powershellCommand = 'Import-Module $Env:RAW_TOOLS_DIR\PowerSploit\PowerSploit.psd1; Get-Command -Module PowerSploit'
VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256 -powershellCommand $powershellCommand

# vars for powerview
$toolName2 = 'PowerView'
$category2 = 'Reconnaissance'
$shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category2
$shortcut = Join-Path $shortcutDir "$toolName2.ps1.lnk"
$targetCmd = Join-Path ${Env:WinDir} "system32\WindowsPowerShell\v1.0\powershell.exe" -Resolve
$executableArgs = '-NoExit Import-Module $Env:RAW_TOOLS_DIR\PowerSploit\Recon\Recon.psd1; Get-Command -Module Recon'

# install powerview shortcut and list available powerview modules
Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $targetCmd -Arguments $executableArgs
VM-Assert-Path $shortcut
