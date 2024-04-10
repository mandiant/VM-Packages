$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RegCool'
$category = 'Registry'
$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

$zipUrl = 'https://kurtzimmermann.com/files/RegCoolX64.zip'

try {
    # Download zip
    $packageArgs      = @{
      packageName     = $env:ChocolateyPackageName
      file            = Join-Path ${Env:TEMP} $toolName
      url             = $zipUrl
    }
    $filePath = Get-ChocolateyWebFile @packageArgs

    # Extract zip
    Get-ChocolateyUnzip -FileFullPath $filePath -Destination $toolDir

    # Check signature of all unzip files
    Get-ChildItem -Path "$toolDir\*.{exe,dll}" | ForEach-Object {
        VM-Assert-Signature $_.FullName
    }
} catch {
    # Remove files with invalid signature
    Remove-Item $toolDir -Recurse -Force -ea 0 | Out-Null
    VM-Write-Log-Exception $_
}

try {
    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $shortcut = Join-Path $shortcutDir "$toolname.lnk"
    $toolPath = Join-Path $toolDir "$toolName.exe"
    Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $toolPath
    VM-Assert-Path $shortcut
} catch {
    VM-Write-Log-Exception $_
}
