$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'asar'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$arguments = '--help'

try {
    # "--no-update-notifier" removes the npm funding notice that may cause an error
    npm install -g '@electron/asar@4.0.0' --loglevel=error --no-update-notifier
    VM-Install-Shortcut -toolName $toolName -category $category -arguments "$toolName $arguments" -powershell
} catch {
    VM-Write-Log-Exception $_
}
