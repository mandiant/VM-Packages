$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking


$toolName = 'hashcat'
$category = 'Credential Access'

$zipUrl = 'https://github.com/hashcat/hashcat/releases/download/v6.2.6/hashcat-6.2.6.7z'
$zipSha256 = '96697e9ef6a795d45863c91d61be85a9f138596e3151e7c2cd63ccf48aaa8783'
$zipName = 'hashcat-6.2.6'
$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} "$toolName"
$workingDir = Join-Path "$toolDir" "$zipname"

try {
    try{
        # Get the processor information
        $processor = Get-WmiObject Win32_Processor


        # Check if the manufacturer is Intel
        if ($processor.Manufacturer -eq "GenuineIntel") {
            Write-Output "Intel processor detected for hashcat."
        } else {
            Write-Output "Non-Intel processor detected. Hashcat will not work"
            throw "Non-Intel processor detected."
        }
    }catch{
        # Handle the error
        Write-Output "Error: $($_.Exception.Message)"
        throw
    }

    # Download the zip file
    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        url           = $zipUrl
        checksum      = $zipSha256
        checksumType  = "sha256"
        fileFullPath  = Join-Path "${Env:USERPROFILE}\AppData\Local\Temp" ("$zipName.7z")
    }
    Get-ChocolateyWebFile @packageArgs
    $zipPath = $packageArgs.fileFullPath
    VM-Assert-Path $zipPath

    7z x $zipPath -o"$toolDir" -y
    # Create a shortcut
    $executablePath = Join-Path "$workingDir" "$toolName.exe" -Resolve
    VM-Install-Shortcut $toolName $category $executablePath -consoleApp $true -executableDir $workingDir
} catch {
    VM-Write-Log-Exception $_
}