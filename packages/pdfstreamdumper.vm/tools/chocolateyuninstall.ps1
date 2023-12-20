$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PDFStreamDumper'
$category = 'PDF'

VM-Uninstall $toolName $category
