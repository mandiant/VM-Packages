$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = "ttd"
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

    # From https://aka.ms/ttd/download
    $bundleUrl = "https://windbg.download.prss.microsoft.com/dbazure/prod/1-11-506-0/TTD.msixbundle"
    $bundleSha256 = "e6db07a44e3d82c29e001006dc839ee60dba1178248d7969c3575cecdc4a5d63"

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
