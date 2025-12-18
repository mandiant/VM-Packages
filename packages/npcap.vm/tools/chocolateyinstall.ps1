$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $exeUrl = 'https://npcap.com/dist/npcap-1.85.exe'
    $exeSha256 = '4038de8dfdd254d21ebc3269c21f138695a07de2d2fbe57181ce4c0da87531c7'
    $installerName = Split-Path -Path $exeUrl -Leaf

    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        url           = $exeUrl
        checksum      = $exeSha256
        checksumType  = "sha256"
        fileFullPath  = Join-Path ${Env:TEMP} $installerName
    }
    Get-ChocolateyWebFile @packageArgs
    VM-Assert-Path $packageArgs.fileFullPath

    $ahkInstaller = Join-Path $(Split-Path $MyInvocation.MyCommand.Definition) "install.ahk" -Resolve
    $process = Start-Process -FilePath $ahkInstaller -ArgumentList $packageArgs.fileFullPath -PassThru
    # Wait for the AutoHotKey script to finish. We need a max time as if something goes wrong
    # (for example the installation takes longer than exception), it will never finish.
    $process.WaitForExit(600000)
    if ($process.ExitCode -eq 1) {
        throw "AutoHotKey returned a failure exit code ($rc) for: ${Env:ChocolateyPackageName}"
    } else {
        VM-Assert-Path $(Join-Path ${Env:PROGRAMFILES} "Npcap\npcap.cat")
    }
} catch {
    VM-Write-Log-Exception $_
}

