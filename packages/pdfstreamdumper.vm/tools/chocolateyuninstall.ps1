$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PDFStreamDumper'
$category = 'Documents'

VM-Uninstall $toolName $category
