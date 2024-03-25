$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'pkg-unpacker'
    $category = 'Packers'
    $zipUrl = 'https://github.com/LockBlock-dev/pkg-unpacker/archive/b1fd5200e1bf656dedef6817c177c8bb2dc38028.zip'
    $zipSha256 = '6eed1d492d37ca3934a3bc838c2256719a3e78ccf72ce1b1ca07684519ace16c'
    $powershellCommand = "npm install; node unpack.js"

    $toolDir = VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256 -innerFolder $true -powershellCommand $powershellCommand
} catch {
  VM-Write-Log-Exception $_
}

# Prevent npm warn/notice to fail the package
$ErrorActionPreference = 'Continue'
# Get absolute path as npm is not in path until Powershell is restarted
$npmPath = Join-Path ${Env:ProgramFiles} "\nodejs\npm.cmd" -Resolve
# Install tool dependencies with npm
Set-Location $toolDir; & "$npmPath" install | Out-Null
