$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'WinDbg'
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

    $bundleUrl = "https://windbg.download.prss.microsoft.com/dbazure/prod/1-2603-20001-0/windbg.msixbundle"
    $bundleSha256 = "d98e7027fc84962dcd93c270195e84b27bacfcf942935043fa457c87aea83532"

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
