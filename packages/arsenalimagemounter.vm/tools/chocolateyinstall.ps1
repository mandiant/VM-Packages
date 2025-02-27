$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  ###################################
  # Install of drivers dependencies #
  ###################################
  $zipCliUrl = 'https://github.com/ArsenalRecon/Arsenal-Image-Mounter/raw/02e94240383111915a39734e1648d361a7013251/Command%20line%20applications/aim_ll.zip'
  $zipCliSha256 = '3b4121868446012f63a3d162db976bdfe42bb7926d46a39aba849c60657f88b0'
  $tempCliDownloadDir = Join-Path ${Env:chocolateyPackageFolder} "aim_ll"
  $toolCli = "aim_ll.exe"

  $zipDriverUrl = 'https://github.com/ArsenalRecon/Arsenal-Image-Mounter/raw/02e94240383111915a39734e1648d361a7013251/DriverSetup/DriverFiles.zip'
  $zipDriverSha256 = '0aa82ab50be6deb6f3d8fa38d2a9391913d71ca3fb7c7f7b80e3c2ae79802d54'
  $tempDriverDownloadDir = Join-Path ${Env:TEMP} "temp_$([guid]::NewGuid())"

  $packageArgs = @{
      packageName    = ${Env:ChocolateyPackageName}
      unzipLocation  = $tempCliDownloadDir
      url            = $zipCliUrl
      checksum       = $zipCliSha256
      checksumType   = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs
  VM-Assert-Path $tempCliDownloadDir

  $packageArgs = @{
      packageName    = ${Env:ChocolateyPackageName}
      unzipLocation  = $tempDriverDownloadDir
      url            = $zipDriverUrl
      checksum       = $zipDriverSha256
      checksumType   = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs | Out-Null
  VM-Assert-Path $tempDriverDownloadDir

  if (Get-OSArchitectureWidth -Compare 64) {
      $toolCliDir = Join-Path $tempCliDownloadDir "x64"
  }
  else {
      $toolCliDir = Join-Path $tempCliDownloadDir "x32"
  }
  $toolCliPath = Join-Path $toolCliDir $toolCli
  # Install drivers messages displayed in stderr even on successful install, bypass by creating an external process
  Start-Process -FilePath $toolCliPath -ArgumentList "--install $tempDriverDownloadDir" -Wait

  ######################
  # Install of package #
  ######################
  $toolName = 'ArsenalImageMounter'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)
  $shimPath = "\bin\${toolName}.exe"

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executablePath = Join-Path ${Env:ChocolateyInstall} $shimPath -Resolve
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}