$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {

    $toolName = 'OneNoteAnalyzer'
    $category = 'Office'

    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
    $zipUrl = 'https://github.com/knight0x07/OneNoteAnalyzer/releases/download/OneNoteAnalyzer/OneNoteAnalyzer-withPass.zip'
    $zipSha256 = 'a8b04313cf73360b828624a423435b2f2b4652a16c421170b2400966e6ac77cc'

    $packageArgs = @{
        packageName    = ${Env:ChocolateyPackageName}
        unzipLocation  = $toolDir
        url            = $zipUrl
        checksum       = $zipSha256
        checksumType   = 'sha256'
    }
    Install-ChocolateyZipPackage @packageArgs
    VM-Assert-Path $toolDir

    $executablePath = Join-Path $toolDir "OneNoteAnalyzer-withPass\OneNoteAnalyzer_withPass.exe" -Resolve
    VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath -consoleApp $true -arguments "--help"
} catch {
    VM-Write-Log-Exception $_
}
