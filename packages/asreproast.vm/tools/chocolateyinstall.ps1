$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ASREPRoast'
$Category = 'Credential Access'

$zipUrl = 'https://codeload.github.com/HarmJ0y/ASREPRoast/zip/1c94ef12038df1378f5e663fe3b8137e46c60896'
$zipSha256 = '3e90bb0755f9076e74ad749a188ad99b9dc11f197d4366a8eaa4f056953e4cab'
$powershellCommand = "Import-Module .\ASREPRoast.ps1; Get-Help Invoke-ASREPRoast"

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256 -powershellCommand $powershellCommand
