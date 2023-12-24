$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Kernel Outlook PST Viewer'
$category = 'Forensic'

$exeUrl = 'https://www.nucleustechnologies.com/dl/dl.php?id=125'
$exeSha256 = '4e2eb12620d5c06822913b82decc1c44d272082ce75a266e0ec3ab4e38c52ab9'

try {
    $toolDir = Join-Path ${Env:ProgramFiles(x86)} $toolName

    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        fileType      = 'EXE'
        url           = $exeUrl
        checksum      = $exeSha256
        checksumType  = 'sha256'
        silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /MERGETASKS="!desktopicon"'
    }
    Install-ChocolateyPackage @packageArgs
    VM-Assert-Path $toolDir

    $executablePath = Join-Path $toolDir "$toolName.exe" -Resolve
    VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath -consoleApp $false
} catch {
    VM-Write-Log-Exception $_
}