$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpExec'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/anthemtotheego/SharpExec/archive/852384499de1ab7b56ee93203b31638138a1d313.zip'
$zipSha256 = 'd032aa7772d8c0d47f30a77381c372cf5d181fea2836c9c85d65eb052785d2df'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
