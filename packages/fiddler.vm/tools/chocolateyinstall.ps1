$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'fiddler'
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $shortcut = Join-Path $shortcutDir "$toolName.lnk"
    $executablePath = Join-Path ${Env:LOCALAPPDATA} "Programs\Fiddler\fiddler.exe" -Resolve
    Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
    VM-Assert-Path $shortcut

    Install-BinFile -Name $toolName -Path $executablePath
} catch {
    VM-Write-Log-Exception $_
}

