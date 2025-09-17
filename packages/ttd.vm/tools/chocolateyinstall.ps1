$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = "ttd"
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

    # From https://aka.ms/ttd/download
    $bundleUrl = "https://windbg.download.prss.microsoft.com/dbazure/prod/1-11-553-0/TTD.msixbundle"
    $bundleSha256 = "f9cd5adf2da0d077e5d9f95a9f099e45fb0f87c51eae17c67db711f29b3e2d4a"

    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        url           = $bundleUrl
        checksum      = $bundleSha256
        checksumType  = "sha256"
        fileFullPath  = Join-Path ${Env:TEMP} "$toolName.msixbundle"
    }

    Get-ChocolateyWebFile @packageArgs
    Add-AppxPackage -Path $packageArgs.fileFullPath

    VM-Install-Shortcut -toolName $toolName -category $category -executablePath "$toolName.exe" -consoleApp $true -runAsAdmin
} catch {
    VM-Write-Log-Exception $_
}
