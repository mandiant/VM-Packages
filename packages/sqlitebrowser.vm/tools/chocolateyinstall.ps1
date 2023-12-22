$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'DB Browser for SQLite'
$subToolName = 'DB Browser for SQLCipher'
$category = 'Utilities'

$exeUrl = 'https://github.com/sqlitebrowser/sqlitebrowser/releases/download/v3.12.2/DB.Browser.for.SQLite-3.12.2-win64.msi'
$exeSha256 = '723d601f125b0d2402d9ea191e4b310345ec52f76b61e117bf49004a2ff9b8ae'

$toolDir = Join-Path ${Env:ProgramFiles} $toolName
$executablePath = Join-Path $toolDir "$toolName.exe"
$subExecutablePath = Join-Path $toolDir "$subToolName.exe"

VM-Install-With-Installer -toolName $toolName -category $category -fileType "MSI" -silentArgs "/qn /norestart" -executablePath $executablePath -url $exeUrl -sha256 $exeSha256

try {
    VM-Install-Shortcut -toolName $subToolName -category $category -executablePath $subExecutablePath
} catch {
    VM-Write-Log-Exception $_
}