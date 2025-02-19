$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$shimPath = Join-Path ${Env:ChocolateyInstall} "bin" -Resolve
$toolPaths = Get-ChildItem $shimPath | Where-Object { $_.Name -match '^yarac?(32|64)\.exe$' }

foreach ($toolPath in $toolPaths) {
    $toolName = $toolPath.Name -replace ([regex]::match($toolPath.Name, '(32|64)\.exe')), ''
    VM-Remove-Tool-Shortcut $toolName $category
    Uninstall-BinFile -Name $toolName
}
