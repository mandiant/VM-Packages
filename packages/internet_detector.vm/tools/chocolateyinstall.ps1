$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'internet_detector'
$category = 'Networking'
$packageToolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Create tool directory
$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
New-Item -Path $toolDir -ItemType Directory -Force -ea 0
VM-Assert-Path $toolDir

# Install pyinstaller 6.11.1 (needed to build the Python executable with a version capable of executing in admin cmd) and tool dependencies ('pywin32')
$dependencies = "pyinstaller==6.11.1,pywin32"
VM-Pip-Install $dependencies

# This wrapper is needed because PyInstaller emits an error when running as admin and this mitigates the issue.
Start-Process -FilePath 'cmd.exe' -WorkingDirectory $toolDir -ArgumentList "/c pyinstaller --onefile -w --log-level FATAL --distpath $toolDir --workpath $packageToolDir --specpath $packageToolDir $packageToolDir\internet_detector.pyw" -Wait

# Move images to %VM_COMMON_DIR% directory
$imagesPath = Join-Path $packageToolDir "images"
Copy-Item "$imagesPath\*" ${Env:VM_COMMON_DIR} -Force

VM-Install-Shortcut -toolName $toolName -category $category -executablePath "$toolDir\$toolName.exe"

# Create scheduled task for tool to run every 2 minutes.
$action = New-ScheduledTaskAction -Execute "$toolDir\$toolName.exe"
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 1)
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName 'Internet Detector' -Force