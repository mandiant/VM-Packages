$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'setdllcharacteristics'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://www.didierstevens.com/files/software/setdllcharacteristics_v0_0_0_1.zip'
$zipSha256 = '5a9d3815f317c7c0ff7737f271ce0c60be2cb0f4168c5ea5ad8cef84ad718577'

# www.didierstevens.com doesn't have a valid SSL certificate so override the
# certificate verification callback to always return true.
$certValidateCB = [System.Net.ServicePointManager]::ServerCertificateValidationCallback
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
try {
    VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true
}
# Re-throw the occured exception (if any).
catch { throw }
finally {
    # Make sure the certificate verification callback is restored to its original
    # value under any condition.
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = $certValidateCB
}
