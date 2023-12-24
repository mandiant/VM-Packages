$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpExec'
$category = 'Lateral Movement'

$zipUrl = 'https://github.com/anthemtotheego/SharpExec/archive/852384499de1ab7b56ee93203b31638138a1d313.zip'
$zipSha256 = 'd032aa7772d8c0d47f30a77381c372cf5d181fea2836c9c85d65eb052785d2df'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
