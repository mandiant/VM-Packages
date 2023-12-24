$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Kernel OST Viewer'
$category = 'Forensic'

$exeUrl = 'https://www.nucleustechnologies.com/dl/dl.php?id=127'
$exeSha256 = 'f3ec61fe2f01c121e7436cfb6440e839795c280382409fd454f7814f99a20638'

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