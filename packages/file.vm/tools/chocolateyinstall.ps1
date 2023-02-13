$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'file'
    $category = 'Utilities'

    $zipUrl = "https://github.com/nscaife/file-windows/releases/download/20170108/file-windows-20170108.zip"
    $zipSha256 = "963147318f96d9345471e1a9a3943def4d95fcb3c1fe020e465ab910d0cda4a3"

    $executablePath = (VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true)[-1]
    
    $executableDir = Split-Path -Path $executablePath
    $scriptPath = Join-Path $executableDir "leave_file_open.bat"
    [IO.File]::WriteAllLines($scriptPath, $("`"$executablePath`" %1", "PAUSE"))

    VM-Add-To-Right-Click-Menu $toolName "file type" "`"$scriptPath`" `"%1`"" "file"
} catch {
    VM-Write-Log-Exception $_
}
