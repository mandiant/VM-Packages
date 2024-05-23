$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'TestDisk'
$category = 'Forensic'

$zipUrl = "https://www.cgsecurity.org/testdisk-7.2.win64.zip"
$zipSha256 = 'e97e203ce77b6b1a3a37d01beccf069dc6c4632b579ffbb82ae739cdda229f38'

try {
    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

    # Remove files from previous zips for upgrade
    VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

    # Download and unzip
    $packageArgs = @{
        packageName    = ${Env:ChocolateyPackageName}
        unzipLocation  = $toolDir
        url            = $zipUrl
        checksum       = $zipSha256
        checksumType   = 'sha256'
    }
    Install-ChocolateyZipPackage @packageArgs
    VM-Assert-Path $toolDir

    $dirList = Get-ChildItem $toolDir -Directory
    $toolDir = Join-Path $toolDir $dirList[0].Name -Resolve

    $subTools = @(
        [PSCustomObject]@{ Name = 'testdisk'; ConsoleApp = $true; Arguments = "" }
        [PSCustomObject]@{ Name = 'photorec'; ConsoleApp = $true; Arguments = "" }
        [PSCustomObject]@{ Name = 'qphotorec'; ConsoleApp = $false; Arguments = "" }
        [PSCustomObject]@{ Name = 'fidentify'; ConsoleApp = $true; Arguments = "--help" }
    )
    foreach ($subTool in $subTools) {
        $executablePath = Join-Path $toolDir "$($subTool.Name)_win.exe" -Resolve
        VM-Install-Shortcut -toolName $subTool.Name -category $category -executablePath $executablePath -consoleApp $subTool.ConsoleApp -arguments $subTool.Arguments
    }
} catch {
    VM-Write-Log-Exception $_
}
