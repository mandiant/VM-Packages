$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'Metasploit'
    $category = 'Command & Control'

    $exeUrl = 'https://windows.metasploit.com/metasploitframework-latest.msi'
    $exeSha256 = '3247D95D548455D3D59E4977AF48954A574CCE0CAB3C9634CBAD1ECE85668426'
    # can't install to specified path.
    $toolDir = Join-Path ${Env:SystemDrive} "metasploit-framework"
    $binDir = Join-Path $toolDir "bin"
    $executablePath = (Join-Path $binDir "msfconsole.bat")
    VM-Install-With-Installer $toolName $category "MSI" "/q /norestart" $executablePath $exeUrl -sha256 $exeSha256

} catch {
    VM-Write-Log-Exception $_
}
