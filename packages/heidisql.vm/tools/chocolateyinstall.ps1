$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try{
    $toolName = 'HeidiSQL'
    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $toolsDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
    $category = 'Utilities'

    $exeUrl = 'https://www.heidisql.com/installers/HeidiSQL_12.4.0.6659_Setup.exe'
    $exeSha256 = '205da1014259b36891981b1044f5429412b9a3050dfc2e2864b9fd724200f227'
    $installerName = Split-Path -Path $exeUrl -Leaf

    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        url           = $exeUrl
        checksum      = $exeSha256
        checksumType  = "sha256"
        fileFullPath  = Join-Path ${Env:TEMP} $installerName
    }

    Get-ChocolateyWebFile @packageArgs
    VM-Assert-Path $packageArgs.fileFullPath

    # AutoHotkey the installer
    $ahkInstaller = Join-Path ${Env:TEMP} $installerName -Resolve
    $rc = (Start-Process -FilePath $ahkInstaller -ArgumentList '/VERYSILENT', '/SUPPRESSMSGBOXES', '/DIR="C:\Tools\HeidiSQL"' -PassThru -Wait).ExitCode
    if ($rc -eq 1) {
        throw "AutoHotKey returned a failure exit code ($rc) for: ${Env:ChocolateyPackageName}"
    } else {
        VM-Assert-Path $(Join-Path $toolsDir "HeidiSQL.exe")
        # Remove desktop shortcut
        Get-ChildItem 'C:\Users\Public\Desktop\HeidiSQL.lnk' | ForEach-Object { Remove-Item $_ }
    }

    # Add shortcuts for HeidiSQL
    $executablePath = Join-Path $toolsDir "HeidiSQL.exe" -Resolve
    $shortcut = Join-Path $shortcutDir "HeidiSQL.lnk"
    Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
    VM-Assert-Path $shortcut
    Install-BinFile -Name "HeidiSQL" -Path $executablePath

} catch {
    VM-Write-Log-Exception $_
}