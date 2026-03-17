$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)
  $toolName = 'CyberChef'
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = 'https://github.com/gchq/CyberChef/releases/download/v10.22.1/CyberChef_v10.22.1.zip'
    checksum      = '0350fcf57435539622762b6c38eff6dc92def7a9667b7738c4ae0df76cfcfcaa'
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs
  VM-Assert-Path $toolDir

  # FLARE-VM adds CyberChef to the taskbar.
  # We use the chrome executable as we can't use an `.html` shortcut for the taskbar.
  # Because of this reason we are not using the `VM-Install-From-Zip` helper that would simplify the package code.
  $chromePath = "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe"
  $cyberchefPath = Get-Item "$toolDir\CyberChef*.html"
  $iconLocation = VM-Create-Ico (Join-Path $toolDir "images\cyberchef-128x128.png")
  VM-Install-Shortcut -toolName $toolName -category $category -executablePath $chromePath -arguments "-home $cyberchefPath" -iconLocation $iconLocation

  # Refresh Desktop as shortcut is used in FLARE-VM LayoutModification.xml
  VM-Refresh-Desktop
} catch {
  VM-Write-Log-Exception $_
}
