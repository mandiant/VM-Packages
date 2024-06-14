$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'Metasploit'
    $category = 'Command & Control'

    # Download the installer
    $packageArgs        = @{
        packageName     = $env:ChocolateyPackageName
        file            = Join-Path ${Env:TEMP} 'metasploitframework-latest.msi'
        url             = 'https://windows.metasploit.com/metasploitframework-latest.msi'
    }
    $filePath = Get-ChocolateyWebFile @packageArgs
    VM-Assert-Path $filePath
    VM-Assert-Signature $filePath

    # Install the downloaded installer
    $packageArgs        = @{
        packageName     = $env:ChocolateyPackageName
        file            = $filePath
        fileType        = 'MSI'
        silentArgs      = "/quiet /norestart INSTALLLOCATION=$(${Env:SystemDrive})\"
    }
    Install-ChocolateyInstallPackage @packageArgs -ErrorAction SilentlyContinue

    $toolDir = Join-Path ${Env:SystemDrive} "metasploit-framework"
    $binDir = Join-Path $toolDir "bin"
    $executablePath = (Join-Path $binDir "msfconsole.bat")
    VM-Assert-Path $executablePath

    VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath
    Install-BinFile -Name $toolName -Path $executablePath
} catch {
    VM-Write-Log-Exception $_
}
