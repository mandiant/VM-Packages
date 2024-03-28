$ErrorActionPreference = 'Continue'

$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'x64dbg\release'
foreach ($file in $("NewProcessWatcher.exe", "readme_dbgchild.txt", "x64_post.unicode.txt", "x64_pre.unicode.txt", "x86_post.unicode.txt", "x86_pre.unicode.txt", "dbgchildlogs")) {
    Remove-Item "${toolDir}\${file}" -Recurse -Force
}

$archFiles = @("CreateProcessPatch.exe", "DbgChildHookDLL.dll", "NTDLLEntryPatch.exe", "CPIDS")
foreach ($arch in @("32", "64")) {
    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} "x64dbg\release\x${arch}"
    foreach ($file in $archFiles) {
        Remove-Item "${toolDir}\${file}" -Recurse -Force
    }
    Remove-Item "${toolDir}\plugins\dbgchild.dp${arch}" -Force
}