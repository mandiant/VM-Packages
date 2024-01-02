$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'Metasploit'
    $category = 'Command & Control'

    $exeUrl = 'https://windows.metasploit.com/metasploitframework-latest.msi'
    $exeSha256 = 'D3650531A63A473C0AE0D272A6ABC8EFF7D9AD22F971B21D2ED99199344904E7'
    # can't install to specified path.
    $toolDir = Join-Path ${Env:SystemDrive} "metasploit-framework"
    $binDir = Join-Path $toolDir "bin"
    $executablePath = (Join-Path $binDir "msfconsole.bat")
    VM-Install-With-Installer $toolName $category "MSI" "/q /norestart" $executablePath $exeUrl -sha256 $exeSha256

} catch {
    VM-Write-Log-Exception $_
}
