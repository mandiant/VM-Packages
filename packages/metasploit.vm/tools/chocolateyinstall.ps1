$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'Metasploit'
    $category = 'Command & Control'

    $exeUrl = 'https://windows.metasploit.com/metasploitframework-latest.msi'
    $exeSha256 = '9ADEAF4002D1D117642CF089101DCC7434F4D202BA9775CDA92ACA231FD49405'
    # can't install to specified path.
    $toolDir = Join-Path ${Env:SystemDrive} "metasploit-framework"
    $binDir = Join-Path $toolDir "bin"
    $executablePath = (Join-Path $binDir "msfconsole.bat")
    VM-Install-With-Installer $toolName $category "MSI" "/q /norestart" $executablePath $exeUrl -sha256 $exeSha256

} catch {
    VM-Write-Log-Exception $_
}
