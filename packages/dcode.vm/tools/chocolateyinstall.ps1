$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'DCode'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$url = 'https://www.digital-detective.net/download/download.php?downcode=ae2znu5994j1lforlh03'
$sha256 = '9ffe1106ee9d9f55b53d5707621d5990f493604e20f3dbdb0d22ec1b8ecb2458'

$toolDir = Join-Path ${Env:ProgramFiles(x86)} "Digital Detective"
$toolDir = Join-Path $toolDir "$toolName v5"
$executablePath = Join-Path $toolDir "$toolName.exe"

$fileType = "EXE"
$silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /MERGETASKS="!desktopicon"'
$validExitCodes= @(0, 3010, 1605, 1614, 1641)
$consoleApp=$false
$arguments = ""
#VM-Install-With-Installer -toolName $toolName -category $category -fileType "EXE" -silentArgs '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /MERGETASKS="!desktopicon"' -executablePath $executablePath -url $exeUrl -sha256 $exeSha256

try {
    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

    # Get the file extension from the URL
    $installerName = Split-Path -Path $url -Leaf
    $ext = "zip"

    # Download and install
    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        url           = $url
        checksum      = $sha256
        checksumType  = "sha256"
    }
    if ($ext -in @("zip", "7z")) {
        VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}
        $unzippedDir= Join-Path $toolDir "$($toolName)_installer"
        $packageArgs['unzipLocation'] = $unzippedDir
        Install-ChocolateyZipPackage @packageArgs
        VM-Assert-Path $unzippedDir

        $exePaths = Get-ChildItem $unzippedDir | Where-Object { $_.Name.ToLower() -match '^.*\.(exe|msi)$' }
        if ($exePaths.Count -eq 1) {
            $installerPath = $exePaths[0].FullName
        } else {
            $exePaths = Get-ChildItem $unzippedDir | Where-Object { $_.Name.ToLower() -match '^.*(setup|install).*\.(exe|msi)$' }
            if ($exePaths.Count -eq 1) {
                $installerPath = $exePaths[0].FullName
            } else {
                throw "Unable to determine installer file within: $unzippedDir"
            }
        }
    } else {
        $installerPath = Join-Path $toolDir $installerName
        $packageArgs['fileFullPath'] = $installerPath
        Get-ChocolateyWebFile @packageArgs
        VM-Assert-Path $installerPath
    }

    # Install tool via native installer
    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        fileType      = $fileType
        file          = $installerPath
        silentArgs    = $silentArgs
        validExitCodes= $validExitCodes
        softwareName  = $toolName
    }
    Install-ChocolateyInstallPackage @packageArgs
    VM-Assert-Path $executablePath

    VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath -consoleApp $consoleApp -arguments $arguments
    Install-BinFile -Name $toolName -Path $executablePath
} catch {
    VM-Write-Log-Exception $_
}
