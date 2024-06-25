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
    # Add-AppxPackage -Path $packageArgs.fileFullPath
    if ($PSEdition -eq 'Core') {
        $Command = "Add-AppxPackage -Path `"$packageArgs.fileFullPath`""
        Start-Process powershell.exe -ArgumentList "-Command", $Command -Wait
    } else {
        Add-AppxPackage -Path $packageArgs.fileFullPath
    }

    $installDir = (Get-AppxPackage -Name "Microsoft.$toolName").InstallLocation
    $iconLocation  = Join-Path $installDir "DbgX.Shell.exe" -Resolve
    $parentPath = Join-Path ${Env:LOCALAPPDATA} "Microsoft\WindowsApps\"
    Write-Host "iconLocation"
    Get-ChildItem -Path $iconLocation
    Write-Host "parent dir"
    Get-ChildItem -Path $parentPath
    $executablePath = Join-Path $parentPath "WinDbgX.exe" -Resolve
    VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath -iconLocation $iconLocation -RunAsAdmin
} catch {
    VM-Write-Log-Exception $_
}
