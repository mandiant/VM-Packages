$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'sysinternals'
$category = 'Utilities'
$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

try {
    # Download zip
    $packageArgs      = @{
      packageName     = $env:ChocolateyPackageName
      file            = Join-Path ${Env:TEMP} $toolName
      url             = 'https://download.sysinternals.com/files/SysinternalsSuite.zip'
    }
    $filePath = Get-ChocolateyWebFile @packageArgs

    # Extract zip
    Get-ChocolateyUnzip -FileFullPath $filePath -Destination $toolDir

    # Check signature of all unzip files
    Get-ChildItem -Path "$toolDir\*.exe" | ForEach-Object {
        VM-Assert-Signature $_.FullName
    }
} catch {
    # Remove files with invalid signature
    Remove-Item $toolDir -Recurse -Force -ea 0 | Out-Null
    VM-Write-Log-Exception $_
}

try {
    # Add sysinternals tools to path
    Install-ChocolateyPath $toolDir

    # Ensure strings is high in PATH
    $executablePath = Join-Path $toolDir "strings.exe" -Resolve
    Install-BinFile -Name strings -Path $executablePath

    # Add shortcut to sysinternals folder
    $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
    $shortcut = Join-Path $shortcutDir 'sysinternals.lnk'
    Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $toolDir
    VM-Assert-Path $shortcut

    # Add shortcut for commonly used tools
    $tools = @{
        'Utilities' = @('procexp', 'procmon')
        'Reconnaissance' = @('ADExplorer')
    }
    ForEach ($tool in $tools.GetEnumerator()) {
        $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $tool.key
        ForEach ($toolName in $tool.value) {
            $executablePath = Join-Path $toolDir "$toolName.exe" -Resolve
            $shortcut = Join-Path $shortcutDir "$toolName.lnk"
            Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
            VM-Assert-Path $shortcut
        }
    }

    # Accept EULA
    # https://github.com/chocolatey-community/chocolatey-packages/blob/d1241fd3b34e398a2f12c1232fbf616f364997ea/automatic/sysinternals/tools/helpers.ps1#L3C2-L3C2
    $tools = `
    "AccessChk",        "Active Directory Explorer", "ADInsight",  "Autologon",       "AutoRuns",
    "BGInfo",           "CacheSet",                  "ClockRes",   "Coreinfo",        "Ctrl2cap",
    "DbgView",          "Desktops",                  "Disk2Vhd",   "Diskmon",         "DiskView",
    "Du",               "EFSDump",                   "FindLinks",  "Handle",          "Hex2Dec",
    "Junction",         "LdmDump",                   "ListDLLs",   "LoadOrder",       "Movefile",
    "PageDefrag",       "PendMove",                  "PipeList",   "Portmon",         "ProcDump",
    "Process Explorer", "Process Monitor",           "PsExec",     "psfile",          "PsGetSid",
    "PsInfo",           "PsKill",                    "PsList",     "PsLoggedon",      "PsLoglist",
    "PsPasswd",         "PsService",                 "PsShutdown", "PsSuspend",       "RamMap",
    "RegDelNull",       "Regjump",                   "Regsize",    "RootkitRevealer", "Share Enum",
    "ShellRunas - Sysinternals: www.sysinternals.com",
    "EulaAccepted",       "SigCheck",                "Streams",    "Strings",         "Sync",
    "System Monitor",   "TCPView",                   "VMMap",      "VolumeID",        "Whois",
    "Winobj",           "ZoomIt"
    foreach($tool in $tools) {
        $registryKey = "HKCU:\SOFTWARE\Sysinternals\$tool"
        New-Item -Path $registryKey -Force | Out-Null
        New-ItemProperty -Path $registryKey -Name EulaAccepted -Value 1 -Force | Out-Null
    }

    # Refresh Desktop as the shortcuts are used in FLARE-VM LayoutModification.xml
    VM-Refresh-Desktop
} catch {
    VM-Write-Log-Exception $_
}
