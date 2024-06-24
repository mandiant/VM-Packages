$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = "ttd"
    $category = "Debuggers"

    # From https://aka.ms/ttd/download
    $bundleUrl = "https://windbg.download.prss.microsoft.com/dbazure/prod/1-11-319-0/TTD.msixbundle"
    $bundleSha256 = "f7b80731c3a6994b3763c4100073b101965327d6556fa4bfb553d70ce49be366"

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
