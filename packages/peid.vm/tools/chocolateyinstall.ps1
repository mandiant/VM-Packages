$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'peid'
$category = 'Utilities'

$zipUrl = "https://codeload.github.com/wolfram77web/app-peid/zip/91b0057697fb143205a6071a4482e7ad1ff37e12"
$zipSha256 = "04cec2d03338a52f540b88b9fe4dff5922888beb9a3eea4a23308850400c9ee5"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true

