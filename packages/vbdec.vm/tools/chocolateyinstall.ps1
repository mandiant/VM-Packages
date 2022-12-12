$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'vbdec'
$category = 'VB'

$exeUrl = 'https://github.com/dzzie/pdfstreamdumper/releases/download/vbdec_12.7.22/VBDEC_Setup_SnapShot_12.8.22.exe'
$exeSha256 = 'BAED0DA101D1C5D5A326D5C6D004C811C9D23CB76638F79EAFFA9150DB7E8535'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256
