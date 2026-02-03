$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = "ttd"
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

    # From https://aka.ms/ttd/download
    $bundleUrl = "https://windbg.download.prss.microsoft.com/dbazure/prod/1-11-584-0/TTD.msixbundle"
    $bundleSha256 = "25e397426b2c0ff55e8663ed608114f4d8df3d26888d16914606410031c77b04"

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
