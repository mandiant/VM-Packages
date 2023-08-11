$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'Metasploit'
    $category = 'Command & Control'

    $exeUrl = 'https://windows.metasploit.com/metasploitframework-latest.msi'
    $exeSha256 = '470039711E182C4551169A776AFC8C10B4BAEA1600334449998894B2D725D49A'
    # can't install to specified path.
    $toolDir = Join-Path ${Env:SystemDrive} "metasploit-framework"
    $binDir = Join-Path $toolDir "bin"
    $executablePath = (Join-Path $binDir "msfconsole.bat")
    VM-Install-With-Installer $toolName $category "MSI" "/q /norestart" $executablePath $exeUrl -sha256 $exeSha256

} catch {
    VM-Write-Log-Exception $_
}
