$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $exeUrl = 'https://npcap.com/dist/npcap-1.84.exe'
    $exeSha256 = '90dcda7d4902daf983db653793cf6f91eeaa2de60cdd5fe9c27cdb7da3928910'
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

