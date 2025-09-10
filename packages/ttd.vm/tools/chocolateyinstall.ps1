$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = "ttd"
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

    # From https://aka.ms/ttd/download
    $bundleUrl = "https://windbg.download.prss.microsoft.com/dbazure/prod/1-11-532-0/TTD.msixbundle"
    $bundleSha256 = "278cf8fb893e77860d84a45b1c63d3a49f7630efd665c54a79f238eda392dd12"

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
