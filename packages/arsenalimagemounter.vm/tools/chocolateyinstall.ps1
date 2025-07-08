$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  ###################################
  # Install of drivers dependencies #
  ###################################
  $zipCliUrl = 'https://github.com/ArsenalRecon/Arsenal-Image-Mounter/raw/5961f922c5b99ec29acc4af4b60b909b402eed95/Command%20line%20applications/aim_ll.zip'
  $zipCliSha256 = 'a628fd0bb4b1657b2b89fd8972937b4d9c4b1292ea16764208fa63fc0ce84d54'
  $tempCliDownloadDir = Join-Path ${Env:chocolateyPackageFolder} "aim_ll"
  $toolCli = "aim_ll.exe"

  $zipDriverUrl = 'https://github.com/ArsenalRecon/Arsenal-Image-Mounter/raw/5961f922c5b99ec29acc4af4b60b909b402eed95/DriverSetup/DriverFiles.zip'
  $zipDriverSha256 = 'cc03472b689f23b1c66d1764b7a12e7212146b5c1f70e2613666efcd93b97192'
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
