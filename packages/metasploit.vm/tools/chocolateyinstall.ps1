$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'Metasploit'
    $category = 'Command & Control'

    $exeUrl = 'https://windows.metasploit.com/metasploitframework-latest.msi'
    $exeSha256 = '2ED5A4F9E63929FA468B014515B906473AB2E540BD212C5EE19B98DCF6738169'
    # can't install to specified path.
    $toolDir = Join-Path ${Env:SystemDrive} "metasploit-framework"
    $binDir = Join-Path $toolDir "bin"
    $executablePath = (Join-Path $binDir "msfconsole.bat")
    VM-Install-With-Installer $toolName $category "MSI" "/q /norestart" $executablePath $exeUrl -sha256 $exeSha256

} catch {
    VM-Write-Log-Exception $_
}
