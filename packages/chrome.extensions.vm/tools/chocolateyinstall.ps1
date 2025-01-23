$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $extensions = @(
    # MetaMask
    'nkbihfbeogaeaoehlefnkodbefgpgknn'
    # Phantom
    'bfnaelmomeimhlpmgjnjophhpkkoljpa'
    # BNB Chain Wallet
    'fhbohimaelbohpjbbldcngcnapndodjp'
    # Avira Password Manager
    'caljgklbbfbcjjanaijlacgncafpegll'
    # KeePassXC-Browser
    'oboonakemofpalcgghocfoadofidjkkk'
    # Yoroi
    'ffnbelfdoeiohenkjibnmadjiehjhajb'
    # XDEFI Wallet
    'hmeobnfnfcmdkdcmlblgagmfpfboieaf'
    # ...
  )

  # Installing the extensions under `ExtensionInstallForcelist` so it can be installed
  # and enabled silently, without user interaction. By default, this registry key does
  # not exist and it is not used within Flare-VM.
  # Ref: https://chromeenterprise.google/policies/?policy=ExtensionInstallForcelist

  $regKeyPath = "HKLM:\SOFTWARE\WOW6432Node\Policies\Google\Chrome\ExtensionInstallForcelist"
  $updateUrl = "https://clients2.google.com/service/update2/crx"

  New-Item -Path $regKeyPath -Force -ea 0 | Out-Null
  $valueName = 1
  Foreach ($extensionId in $extensions)
  {
    New-ItemProperty -Path "$regKeyPath" -Name "$valueName" -Type String -Value "$extensionId;$updateUrl" -Force -ea 0 | Out-Null
    $valueName += 1
  }

  $maximumTries = 5
  $chromePath = "${Env:ProgramFiles}\Google\Chrome\Application\chrome.exe"
  $extensionsDir = "${Env:LocalAppData}\Google\Chrome\User Data\Default\Extensions"

  # Stop Chrome if it is already running.
  Stop-Process -Force -Name Chrome -ea 0

  # Start Chrome to load the extensions.
  $chromeProcess = Start-Process -FilePath $chromePath -passthru

  $tries = 0
  $loaded = $false
  while ((-not $loaded) -and ($tries -ne $maximumTries))
  {
    # Wait for the extensions to be loaded.
    Start-Sleep -Seconds 30

    # Make sure all of the extensions are loaded.
    $loaded = $true
    Foreach ($extensionId in $extensions)
    {
      $extensionPath = Join-Path $extensionsDir $extensionId
      if (-not (Test-Path -Path $extensionPath))
      {
        $loaded = $false
        break
      }
    }

    $tries += 1
  }

  # Wait for an extra 60 seconds to make sure all extensions' tabs are opened already.
  Start-Sleep -Seconds 60

  # Close Chrome gracefully.
  if ($chromeProcess.CloseMainWindow())
  {
    Wait-Process -Id $chromeProcess.Id | Out-Null
  }
  else
  {
    # Force kill the process instead.
    Stop-Process -Force -Id $chromeProcess.Id | Out-Null
  }

  if (-not $loaded)
  {
    # Uninstall the extensions if Chrome is unable to load it.
    Remove-Item -Path $regKeyPath -Recurse -Force -ea 0
    throw "Chrome is unable to load the extensions"
  }

} catch {
  VM-Write-Log-Exception $_
}
