$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoStringUngarbler'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$dependencies = "unicorn,capstone,lief"
VM-Pip-Install $dependencies

$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)
    $zipUrl = 'https://github.com/mandiant/gostringungarbler/archive/refs/tags/v1.0.0.zip'
    $zipSha256 = '8fe3278cc04f62782eaf7c17813cd14228160187b87d9aa28514c419986acacf'
        
    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

    # Remove files from previous zips for upgrade
    VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

    $packageArgs = @{
        packageName    = ${Env:ChocolateyPackageName}
        unzipLocation  = $toolDir
        url            = $zipUrl
        checksum       = $zipSha256
        checksumType   = 'sha256'
    }
    Install-ChocolateyZipPackage @packageArgs | Out-Null

    VM-Assert-Path $toolDir 
      
    $pyPath = (Get-Command py).Source
    $filePath = Join-Path $toolDir "$toolName"
    $arguments = "-3.10 " + $filePath + " -h"
    VM-Install-Shortcut -toolName $toolName -category $category -executablePath $pyPath -consoleApp $true -arguments $arguments
      

    # Add tools to Path
    VM-Add-To-Path $toolDir
} catch {
  VM-Write-Log-Exception $_
}
