$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ASREPRoast'
$category = 'Password Attacks'

$zipUrl = 'https://github.com/HarmJ0y/ASREPRoast/archive/refs/heads/master.zip'
$zipSha256 = '9bcfc5c83ede2a11cb23b8b4abc0105ded456e400cdabac8885ed1bef3453ccb'
$powershellCommand = "Import-Module .\ASREPRoast.ps1; Get-Help Invoke-ASREPRoast"

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256 -powershellCommand $powershellCommand