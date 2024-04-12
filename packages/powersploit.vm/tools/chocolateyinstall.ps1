$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

#vars for powersploit
$toolName = 'PowerSploit'
$category = 'Exploitation'

# install powersploit, import module, and list available powersploit modules
$zipUrl = 'https://github.com/ZeroDayLab/PowerSploit/archive/72a88240ed0c6527f3880a1fb15ea7a19589c2d8.zip'
$zipSha256 = '4a86b4b92e97fe6f1d76d8d93d9e481c007809db803cc82f4f0ec86ff7186bcf'
$powershellCommand = 'Import-Module .\PowerSploit.psd1; Get-Command -Module PowerSploit'
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -innerFolder $true -powershellCommand $powershellCommand

# vars for powerview
$toolName2 = 'PowerView'
$category2 = 'Reconnaissance'
$powershellCommand = 'Import-Module .\Recon\Recon.psd1; Get-Command -Module Recon'

# install powerview shortcut and list available powerview modules
$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} "\PowerSploit"
$dirList = Get-ChildItem $toolDir -Directory
$executablePath = Join-Path $toolDir $dirList[0].Name -Resolve
VM-Install-Shortcut -toolName $toolName2 -category $category2 -arguments $powershellCommand -executableDir $executablePath -powershell
