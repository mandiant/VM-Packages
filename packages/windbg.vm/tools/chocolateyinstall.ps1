$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'WinDbg'
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

    $bundleUrl = "https://windbg.download.prss.microsoft.com/dbazure/prod/1-2502-25002-0/windbg.msixbundle"
    $bundleSha256 = "2802c9da1eccdfd488d1364aa601170d44dc37e2c8354be514f5f5a40c9cfcda"

    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        url           = $bundleUrl
        checksum      = $bundleSha256
        checksumType  = "sha256"
        fileFullPath  = Join-Path ${Env:TEMP} "$toolName.msixbundle"
    }
    Get-ChocolateyWebFile @packageArgs
    Add-AppxPackage -Path $packageArgs.fileFullPath

    $toolPackage = Get-AppxPackage -Name "Microsoft.$toolName"
    $iconLocation = Join-Path $toolPackage.InstallLocation "DbgX.Shell.exe" -Resolve
    $executablePath = "shell:AppsFolder\$($toolPackage.PackageFamilyName)!$($toolPackage.Name)"

    VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath -iconLocation $iconLocation -RunAsAdmin
} catch {
    VM-Write-Log-Exception $_
}
