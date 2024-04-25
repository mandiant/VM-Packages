$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RegCool'
$category = 'Registry'
$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

# Digital Certificate Stuff
$modulus = "B8C489AD5379CAE9474FBCE1D49D1EFFB8E0327E9EF09EEDE21C6419FFE8E1A7D51C7168ED210A6E88ADBAF3D2ABD89DDA83F600540F867DC32BA862D4F92AC51F83AB97EC4A6D8F4F564C290F9E2E014BA2FB4ECD0F540C6CB359FDE37BE50DF85D2D6D71CA0FCA2F08D484AF8C1693DD51DD0614D81991199E57B26D45DA0FA6398DD3C8E9733844F983B86A1CF3AAF2EF538ACB39426E144F36F59C997D8F182D839705F6F317964FF7D3F9879DA7750F06010D95DCF9FB022EB1EF8789CAD41FB09148544CF78E86B70559357E6E7E3F1523DFB97BC3443FF097626AC5F0D98EFEA634A3F34F8F07EE1ACFE253A2E29C02F1C8E14B323B8801B7C723153B8D1F0F28DD499FC978794D17C4C9B0B9D8A216971E1E03160D675F2746D00BC329AB90F31FD6A303CD13554D5CF7C28858B68411597B973438224356E5A28E7DB316F827C9A0A6C1F5B979649D220B1E40764C4A6B7163DB3ECC4759CDB2402A9948BA103EECE50D4BC7E018A16F25425787CC5A89C1EC6B96E56E4DB42B9445036918EFC12BF7280A72D4FE2D8A6F6F4AD873D739671152FF4C4342D29B4E368832D6A8A8287EBED1A1753804DEC613C79B9E5AB023A788AED35159FF8CA9F8217EB4941FAF260EE5DA844EA2BFA6A4E044AD70E873E198C62E388BBA68B5D9A2B689A0B60F6814E0114122F25086A3BE3D0B7596211B69295C5C4C0FD07D91"
$publicExponent = @(1,0,1)

try {
    # Ignore checksums due to single URL for package and updates, with no versioning; We perform signature validation instead.
    $env:ChocolateyIgnoreChecksums = $true

    # Download zip
    $packageArgs      = @{
      packageName     = $env:ChocolateyPackageName
      file            = Join-Path ${Env:TEMP} $toolName
      url             = 'https://kurtzimmermann.com/files/RegCoolX64.zip'
    }
    $filePath = Get-ChocolateyWebFile @packageArgs

    # Extract zip
    Get-ChocolateyUnzip -FileFullPath $filePath -Destination $toolDir

    # Check signature of all unzip files
    $exeFiles = Get-ChildItem -Path "$toolDir\*.exe"
    $dllFiles = Get-ChildItem -Path "$toolDir\*.dll"
    $allFiles = $exeFiles + $dllFiles  # Combine into a single array

    $allFiles | ForEach-Object {
        VM-Assert-Signature -filePath $_.FullName -modulus $modulus -publicExponent $publicExponent
    }
} catch {
    # Remove files with invalid signature
    Remove-Item $toolDir -Recurse -Force -ea 0 | Out-Null
    VM-Write-Log-Exception $_
}

try {
    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $shortcut = Join-Path $shortcutDir "$toolname.lnk"
    $toolPath = Join-Path $toolDir "$toolName.exe"
    Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $toolPath
    VM-Assert-Path $shortcut
} catch {
    VM-Write-Log-Exception $_
}
