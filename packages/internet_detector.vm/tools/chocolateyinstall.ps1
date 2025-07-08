$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'internet_detector'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$packageToolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Modify fakenet's configuration to ignore the internet detector traffic
$fakenetConfig = "$Env:RAW_TOOLS_DIR\fakenet\fakenet3.5\configs\default.ini"
VM-Assert-Path $fakenetConfig

$IcmpID = Get-Random -Maximum 0x10000
$config = Get-Content -Path $fakenetConfig
$config = $config -replace '^.*BlackListIDsICMP.*$', "BlackListIDsICMP: $IcmpID"
Set-Content -Path $fakenetConfig -Value $config -Encoding ASCII -Force

# Create tool directory
$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
New-Item -Path $toolDir -ItemType Directory -Force -ea 0
VM-Assert-Path $toolDir

# Set the ICMP ID at the tool script to a randomized value per installation
# to make it harder for a malware to hardcode it and to lower/zero the
# probability of overlapping with any other application sending ping requests.
$scriptPath = "$packageToolDir\internet_detector.pyw"
$tempScript = Join-Path ${Env:TEMP} "temp_$([guid]::NewGuid())"
$script = Get-Content -Path $scriptPath
$script = $script -replace '^ICMP_ID.*$', "ICMP_ID = $IcmpID"
Set-Content -Path $tempScript -Value $script -Encoding ASCII -Force

# This wrapper is needed because PyInstaller emits an error when running as admin and this mitigates the issue.
Start-Process -FilePath 'cmd.exe' -WorkingDirectory "$toolDir" -ArgumentList "/c pyinstaller --onefile -w --log-level FATAL --distpath `"$toolDir`" --workpath `"$packageToolDir`" --specpath `"$packageToolDir`" --name `"$toolName.exe`" `"$tempScript`"" -Wait

# Move images to %VM_COMMON_DIR% directory
$imagesPath = Join-Path $packageToolDir "images"
Copy-Item "$imagesPath\*" ${Env:VM_COMMON_DIR} -Force

VM-Install-Shortcut -toolName $toolName -category $category -executablePath "$toolDir\$toolName.exe"

# Create scheduled task for tool to run at login and every 1 minute.
$action = New-ScheduledTaskAction -Execute "$toolDir\$toolName.exe"
$trigger_1 = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 1)
$trigger_2 = New-ScheduledTaskTrigger -AtLogon
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries `
                                         -DontStopIfGoingOnBatteries `
                                         -StartWhenAvailable `
                                         -ExecutionTimeLimit (New-TimeSpan -Days 0) # 0 = infinite
Register-ScheduledTask -TaskName 'Internet Detector' `
                       -Action $action `
                       -Trigger $trigger_1, $trigger_2 `
                       -Settings $settings `
                       -Force
