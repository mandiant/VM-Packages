$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} "pdf-parser"
    $toolName = "pdf-parser.py"

    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        unzipLocation = $toolDir
        url           = 'https://didierstevens.com/files/software/pdf-parser_V0_7_7.zip'
        checksum      = '576C429FA88CF0A7A110DAB25851D90670C88EC4CD7728329E754E06D8D26A70'
        checksumType  = 'sha256'
    }
    Install-ChocolateyZipPackage @packageArgs
    $toolPath = Join-Path $toolDir $toolName
    VM-Assert-Path $toolPath

    [System.Environment]::SetEnvironmentVariable('Path', ${env:Path} + ";" + $toolDir, [System.EnvironmentVariableTarget]::User)
} catch {
    VM-Write-Log-Exception $_
}