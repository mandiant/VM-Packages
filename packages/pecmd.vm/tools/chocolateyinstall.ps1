$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PECmd'
$category = 'Forensic'
$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

try {
  # Download zip
  $packageArgs      = @{
    packageName     = $env:ChocolateyPackageName
    file            = Join-Path ${Env:TEMP} $toolName
    url             = 'https://download.mikestammer.com/net6/PECmd.zip'
  }
  $filePath = Get-ChocolateyWebFile @packageArgs

  # Extract zip
  Get-ChocolateyUnzip -FileFullPath $filePath -Destination $toolDir
  VM-Assert-Path $toolDir

  # Check signature of all executable files individually
  Get-ChildItem -Path "$toolDir\*.exe" | ForEach-Object {
    try {
        # Check signature for each file
        VM-Assert-Signature $_.FullName
    } catch {
        # Remove the file with invalid signature
        Write-Warning "Removing file '$($_.FullName)' due to invalid signature"
        Remove-Item $_.FullName -Force -ea 0 | Out-Null
        VM-Write-Log-Exception $_
    }
  }

  $executableName = "$toolName.exe"
  $executablePath = Join-Path $toolDir $executableName -Resolve
  VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath -consoleApp $true
  Install-BinFile -Name $toolName -Path $executablePath

} catch {
  VM-Write-Log-Exception $_
}

