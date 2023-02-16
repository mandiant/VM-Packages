$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = "pdf-parser"
    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
    $category = "PDF"

    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        unzipLocation = $toolDir
        url           = 'https://didierstevens.com/files/software/pdf-parser_V0_7_7.zip'
        checksum      = '576C429FA88CF0A7A110DAB25851D90670C88EC4CD7728329E754E06D8D26A70'
        checksumType  = 'sha256'
    }
    Install-ChocolateyZipPackage @packageArgs
    $toolPath = Join-Path $toolDir "$toolName.py"
    VM-Assert-Path $toolPath

    Install-ChocolateyPath -PathToInstall $toolDir -PathType User

    # This shortcut will not be super useful: we can't provide the required command-line args because the path to the PDF changes every time.
    # But it'll show up in the Start menu and the user will see how to use it.
    # Then they can manually invoke it because they'll be in its direcory and it's in the $PATH anyway.
    $targetCmd  = Join-Path ${Env:WinDir} "system32\cmd.exe" -Resolve
    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $shortcut = Join-Path $shortcutDir "$toolName.lnk"
    $targetArgs = "/k `"$toolPath`""

    Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $targetCmd -Arguments $targetArgs -WorkingDirectory $toolDir
} catch {
    VM-Write-Log-Exception $_
}