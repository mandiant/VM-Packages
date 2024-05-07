$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = '7z'
    $category = 'Productivity Tools'

    $url = 'https://github.com/myfreeer/7z-build-nsis/releases/download/23.01/7z2301-x86.exe'
    $checksum = '7b1d50073e6d3631267f2bbb986fb1faffddc5fc72d6bc23e10b5920a6f365b4'
    $url64 = 'https://github.com/myfreeer/7z-build-nsis/releases/download/23.01/7z2301-x64.exe'
    $checksum64 = 'b7f1d8360d988808447f9af3989db7665dfec72bac83c8b6467cc35f8fe718ff'

    $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    fileType      = 'EXE'
    url           = $url
    url64bit      = $url64
    checksumType  = 'sha256'
    checksum      = $checksum
    checksum64    = $checksum64
    silentArgs    = '/S'
    }
    Install-ChocolateyPackage @packageArgs

    $toolDir = Join-Path ${Env:ProgramFiles} '7-Zip' -Resolve
    $7zExecutablePath = Join-Path $toolDir "$toolName.exe" -Resolve
    Install-BinFile -Name $toolName -Path $7zExecutablePath

    # Make shortcut point to 7z File Manager so that it's more useful of a shortcut.
    $executablePath = Join-Path $toolDir "${toolName}FM.exe" -Resolve
    VM-Install-Shortcut $toolName $category $executablePath

    # Add 7z unzip with password "infected" to the right menu for the most common extensions.
    # 7z can unzip other file extensions like .docx but these don't likely use the infected password.
    $extensions = @(".7z", ".bzip2", ".gzip", ".tar", ".wim", ".xz", ".txz", ".zip", ".rar")
    foreach ($extension in $extensions) {
      VM-Add-To-Right-Click-Menu $toolName 'unzip "infected"' "`"$7zExecutablePath`" x -pinfected `"%1`"" "$executablePath" -extension $extension
      VM-Set-Open-With-Association $executablePath $extension
    }
} catch {
  VM-Write-Log-Exception $_
}
