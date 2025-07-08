$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Invoke-TheHash'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

# install invoke-thehash and import module
$zipUrl = 'https://github.com/Kevin-Robertson/Invoke-TheHash/archive/01ee90f934313acc7d09560902443c18694ed0eb.zip'
$zipSha256 = '9bd8f52de5d1cc2ca39b79fb169699cda88e6c6826ba1e3f2c1890e4b970d41f'
$powershellCommand = 'Import-Module .\Invoke-TheHash.psd1;Get-Command -Module Invoke-TheHash'
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -innerFolder $true -powershellCommand $powershellCommand
