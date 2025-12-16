$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'stringsifter'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

# Create output file to log python module installation details
$outputFile = VM-New-Install-Log ${Env:VM_COMMON_DIR}
Invoke-Expression "py -3.11 -W ignore -m pip install $toolName --disable-pip-version-check 2>&1 >> $outputFile"

$cmdPath = (Get-Command cmd.exe).Source
VM-Install-Shortcut -toolName $toolName -category $category -executablePath "flarestrings" -consoleApp $true -iconLocation $cmdPath
