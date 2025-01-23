$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'VisualStudio'
    $category = 'Productivity Tools'

    # Install with choco instead as dependency to provide params to add common components
    # The community package chocolatey-visualstudio.extension 1.11 includes a -DefaultParameterValues parameter
    # that would be a better solution (as it would allow to change the parameters when installing the package),
    # but only a preview is available at the moment.
    choco install visualstudio2022community --params "--add Microsoft.VisualStudio.Component.CoreEditor --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.ManagedDesktop --includeRecommended" --execution-timeout 6000 --no-progress

    $executablePath = Join-Path ${Env:ProgramFiles} "Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe" -Resolve
    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $shortcut = Join-Path $shortcutDir "$toolName.lnk"
    Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath
    VM-Assert-Path $shortcut

    # Refresh Desktop as shortcut is used in FLARE-VM LayoutModification.xml
    VM-Refresh-Desktop
} catch {
    VM-Write-Log-Exception $_
}
