$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)
    $shimPath = Join-Path ${Env:ChocolateyInstall} "bin" -Resolve
    $toolPaths = Get-ChildItem $shimPath | Where-Object { $_.Name -match '^yarac?(32|64)\.exe$' }

    foreach ($toolPath in $toolPaths) {
        $toolName = $toolPath.Name -replace ([regex]::match($toolPath.Name, '(32|64)\.exe')), ''
        Install-BinFile -Name $toolName -Path $toolPath
        VM-Install-Shortcut -toolName $toolName -category $category -executablePath $toolPath -consoleApp $true -arguments "--help"
    }
} catch {
    VM-Write-Log-Exception $_
}
