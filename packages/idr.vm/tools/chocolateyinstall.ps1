$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    # The way of distributing this tool is unusual, so we can't use the helper functions
    $toolName = 'idr'
    $category = 'Delphi'

    $zipUrl = 'https://github.com/crypto2011/IDR/archive/a404dda53283788330ec5548515536d51c5724a4.zip'
    $zipSha256 = '7cf9d3909011c0eaac48d51dd52553dfedd6959373cecf21739feebd08ea7ab1'

    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

    # Create a temp directory to download zip
    $tempDownloadDir = Join-Path ${Env:chocolateyPackageFolder} "temp_$([guid]::NewGuid())"

    # Download and unzip
    $packageArgs = @{
        packageName    = ${Env:ChocolateyPackageName}
        unzipLocation  = $tempDownloadDir
        url            = $zipUrl
        checksum       = $zipSha256
        checksumType   = 'sha256'
    }
    Install-ChocolateyZipPackage @packageArgs | Out-Null
    VM-Assert-Path $tempDownloadDir

    # Get the unzipped directory
    $unzippedDir = (Get-ChildItem -Directory $tempDownloadDir | Where-Object {$_.PSIsContainer} | Select-Object -f 1).FullName

    # Create tool directory and copy needed files to it
    New-Item -Path $toolDir -ItemType Directory -Force | Out-Null
    Move-Item "$unzippedDir\bin\idr.exe" $toolDir -Force
    Move-Item "$unzippedDir\bin\dis.dll" $toolDir -Force
    Move-Item "$unzippedDir\bin\Icons.dll" $toolDir -Force
    Move-Item "$unzippedDir\*.bin" $toolDir -Force

    # Attempt to remove temporary directory
    Remove-Item $tempDownloadDir -Recurse -Force -ea 0

    $executablePath = Join-Path $toolDir "$toolName.exe" -Resolve
    VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath

    # Download knowledge bases, continue if failure as Google Drive may not work for all or them
    $ErrorActionPreference = 'Continue'
    $bases = @(@{url="https://drive.google.com/u/0/uc?id=1LDXNcyMShVrtb12ie_8w4RnxWiae4VDt&export=download"; sha256 = "a7218634770de83c4461065d73135709b6381020708a9146905d3b4e3cd01d43"}, # kb2014
               @{url="https://drive.google.com/u/0/uc?id=1czqvxZ15KlLXVKxWvjsSUIte_P4iqb6l&export=download"; sha256 = "54da759a2a62e857af287116ff29032a7a937ec5b771f5db48fe31febb764859"}, # kb2013
               @{url="https://drive.google.com/u/0/uc?id=1NbMPUGSCF7NpoIeu6vOuP0-JB9U6ND7Y&export=download"; sha256 = "b242ebad6a7a8894ad9d3469874b5514ee2f37a79c73b262b6142dde404aebb6"}, # kb2012
               @{url="https://drive.google.com/u/0/uc?id=1ekuPj49n6yTM_vTizdaiDt7WbOkge8Qd&export=download"; sha256 = "7e3d7e4445f49d2e2a7cb67243c344bdb9bfaf06c7ba6a01094fb47736102b54"}, # kb2011
               @{url="https://drive.google.com/u/0/uc?id=1OKEwms_zUsMJxGJGCDVkGfBhLV_lUPgy&export=download"; sha256 = "95800f4ead2c1bcb71017dbcdff0046d41f6e6e19cebcb594e0010f7e7e5de90"}, # kb2010
               @{url="https://drive.google.com/u/0/uc?id=16PREPxK6gJINAFC7TvS4k6qtXiZ71aEr&export=download"; sha256 = "0fcf0195f9aecee75be23af760eb3da6971a3a796f579ebdbe8735ba2788739e"}, # kb2009
               @{url="https://drive.google.com/u/0/uc?id=1q3bGNWyvmFTS1RUOzTZUIgwLKYJKsvJZ&export=download"; sha256 = "ff4ffc528f8773320e47fc4d8cc96a5caed810e75d8eb94936efcf880dd86bb3"}, # kb2007
               @{url="https://drive.google.com/u/0/uc?id=1dy1_sSnrWyXy-jwfTlL7ObXk7dHJLfcZ&export=download"; sha256 = "16a7b97f727c14343bf93fb095c275c6e3915c47025b2e1e904a4273b2d676d8"}, # kb2006
               @{url="https://drive.google.com/u/0/uc?id=1pVfkrTC3Cb3e_FxdF5uiATvHmIo93mPO&export=download"; sha256 = "025f07f121c32dc23e552a80fc2f8a2382e04f0b35c86f22185aad7d7694ff2b"}, # kb2005
               @{url="https://drive.google.com/u/0/uc?id=1bvkbANJW9GH9MgCslBBmwPPgiSiDcqVd&export=download"; sha256 = "1913e7964da828496e1a37f562c9e1dbe7cde049b4306185ccc5d28d450c865b"}, # kb7
               @{url="https://drive.google.com/u/0/uc?id=1QshJJ0QI9q4BPrD2nbQhrauiI3tLV7AB&export=download"; sha256 = "62cc81a522afa5334ee1507a4167247cc0a7d452ca8d36bbe2e2d973af5098c6"}, # kb6
               @{url="https://drive.google.com/u/0/uc?id=11eV8O6JME_Hz1UeW-PE8nYE9hVtsRJIb&export=download"; sha256 = "d49dea3261d75c177b61e3942ecfe61396aa05d363eb8ed93d01ca795620c5a5"}, # kb5
               @{url="https://drive.google.com/u/0/uc?id=132cKFOvCJQDp5Bewuf5uIh41s0ab5zaT&export=download"; sha256 = "9c2ab31261946082d47f859687b0e62415803f5c50516d9a80ef9bf8291bb1f4"}, # kb4
               @{url="https://drive.google.com/u/0/uc?id=1gui9JmWa7MaEWUZnMcE1DTg_K3qgFoCO&export=download"; sha256 = "1df45abfb839300b1ec555ca77a841caa4b9d83727e0f2c18f3b42ca0fe82ef9"}, # kb3
               @{url="https://drive.google.com/u/0/uc?id=1Y2jlfb1Lqu21K4QofSyE3APFvZM6ijH3&export=download"; sha256 = "afbdeb2dc8ac38e9ef69c6b22542bbbd50287256b3eb497e5294440b95c15e7b"}) # kb2
    foreach ($base in $bases) {
        try {
            $packageArgs = @{
                packageName    = "${Env:ChocolateyPackageName}.$($base.Substring(0,6))"
                unzipLocation  = $toolDir
                url = $base.url
                checksum = $base.sha256
                checksumType   = 'sha256'
            }
            Install-ChocolateyZipPackage @packageArgs | Out-Null
        } catch {
            Write-Host "`t[!] Failed to download knowledge base from $($base.url)" -ForegroundColor Red
        }
    }
    exit 0
} catch {
    VM-Write-Log-Exception $_
}

