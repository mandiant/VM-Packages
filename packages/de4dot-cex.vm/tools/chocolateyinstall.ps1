$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'de4dot'
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

    $zipUrl = 'https://github.com/ViRb3/de4dot-cex/releases/download/v4.0.0/de4dot-cex.zip'
    $zipSha256 = 'C726CBD18B894CA63B7F6A565C6C86EF512B96E68119C6502CDF64A51F6A1C78'

    VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true

    # Add link for de4dot-x64.exe
    $executablePath = Join-Path ${Env:RAW_TOOLS_DIR} "de4dot\$toolName-x64.exe" -Resolve
    VM-Install-Shortcut "$toolName-x64" $category $executablePath -consoleApp $true
} catch {
    VM-Write-Log-Exception $_
}
