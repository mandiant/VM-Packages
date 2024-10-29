$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'internet_detector'
$category = 'Networking'
$packageToolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Create tool directory
$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
New-Item -Path $toolDir -ItemType Directory -Force -ea 0
VM-Assert-Path $toolDir

# Install pyinstaller (needed to build the Python executable) and tool dependencies ('pywin32')
$dependencies = "pyinstaller,pywin32"
VM-Pip-Install $dependencies

# This wrapper is needed because we can't run PyInstaller as admin, so this forces a usermode context.
Start-Process -FilePath 'cmd.exe' -ArgumentList "/c pyinstaller --onefile -w --distpath $toolDir --workpath $packageToolDir --specpath $packageToolDir $packageToolDir\internet_detector.pyw" -Wait

# Move images to %VM_COMMON_DIR% directory
$imagesPath = Join-Path $packageToolDir "images"
Copy-Item "$imagesPath\*" ${Env:VM_COMMON_DIR} -Force

VM-Install-Shortcut -toolName $toolName -category $category -executablePath "$toolDir/$toolName.exe"

# TODO - Uncomment when FakeNet BlackList for DNS is fixed/addressed. https://github.com/mandiant/flare-fakenet-ng/issues/190
# # Create scheduled task for tool to run every 2 minutes.
# $action = New-ScheduledTaskAction -Execute $rawToolPath
# $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 2)
# Register-ScheduledTask -Action $action -Trigger $trigger -TaskName 'Internet Detector' -Force
