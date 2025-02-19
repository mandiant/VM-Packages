$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'WinDbg'
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

    $bundleVersion = "1-2402-24001"
    $bundleUrl = "https://windbg.download.prss.microsoft.com/dbazure/prod/$bundleVersion-0/windbg.msixbundle"
    $bundleSha256 = "e941076cb4d7912d32a22ea87ad2693c01fa465227b4d1ead588283518de428f"

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
