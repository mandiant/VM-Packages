$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ArsenalImageMounter'
$category = 'Forensic'

VM-Remove-Tool-Shortcut $toolName $category

$tempCliDownloadDir = Join-Path ${Env:chocolateyPackageFolder} "aim_ll"
$toolCli = "aim_ll.exe"

if (Get-OSArchitectureWidth -Compare 64) {
	$toolCliDir = Join-Path $tempCliDownloadDir "x64"
}
else {
	$toolCliDir = Join-Path $tempCliDownloadDir "x32"
}

$toolCliPath = Join-Path $toolCliDir $toolCli
& $toolCliPath "--uninstall"
