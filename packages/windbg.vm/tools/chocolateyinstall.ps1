$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'WinDbg'
    $category = 'Debuggers'

    $bundleUrl = "https://windbg.download.prss.microsoft.com/dbazure/prod/1-2402-24001-0/windbg.msixbundle"
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

    $installDir = (Get-AppxPackage -Name "Microsoft.$toolName").InstallLocation
    $iconLocation  = Join-Path $installDir "DbgX.Shell.exe" -Resolve
    $executablePath = "$(where.exe WinDbgXA.exe)"
    VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath -iconLocation $iconLocation -RunAsAdmin
} catch {
    if ($_.Exception.Message -match "INFO: Could not find files for the given pattern\(s\).")
    {
        $executablePath = Join-Path $installDir "DbgX.Shell.exe"
        VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath -iconLocation $iconLocation -RunAsAdmin
    }
    else
    {
        VM-Write-Log-Exception $_
    }
}

