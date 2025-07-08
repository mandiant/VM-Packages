$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'ImHex'
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $shortcut = Join-Path $shortcutDir "$toolName.lnk"
    $executablePath = Join-Path ${Env:ChocolateyInstall} "bin\imhex.exe" -Resolve
    Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath
    VM-Assert-Path $shortcut

    VM-Add-To-Right-Click-Menu $toolName $toolName "`"$executablePath`" `"%1`"" "$executablePath"
} catch {
    VM-Write-Log-Exception $_
}