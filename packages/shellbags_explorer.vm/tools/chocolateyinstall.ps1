$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ShellBagsExplorer'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.ericzimmermanstools.com/net9/ShellBagsExplorer.zip'
$zipSha256 = '750c2b298945ec871f134804f39334bb764bbfb1bb7d0615e5f08a8ae2694a43'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $true
$rawToolDir = Join-Path $Env:RAW_TOOLS_DIR "$toolName\$toolName"
$settingsPath = Join-Path $rawToolDir "Settings\Settings.json"

VM-Write-Log "INFO" "Configuring $toolName settings."

if (Test-Path $settingsPath) {
    VM-Write-Log "INFO" "Existing settings found. Updating values."
    $jsonConfig = Get-Content -Path $settingsPath -Raw | ConvertFrom-Json

    # Disable telemetry and bypass the initial configuration popup for a better UX
    $jsonConfig.SubmitUnknown = "false"
    $jsonConfig.Email = "."

    $jsonConfig | ConvertTo-Json -Compress | Set-Content -Path $settingsPath
} else {
    VM-Write-Log "INFO" "No settings found. Pre-seeding Settings.json to suppress telemetry and first-run prompts."

    $defaultConfig = @{
        DateTimeFormat = "yyyy-MM-dd HH:mm:ss"
        ActiveSkinName = "Office 2016 Colorful"
        "splitMain.SplitterPosition" = "350"
        "splitRight.SplitterPosition" = "290"
        Height = "800"
        Width = "1200"
        exportExt = "csv"
        ShowHexInString = "False"
        showParentOnFilter = "False"
        ColumnAutoWidth = "False"
        DataInterpreterLocationX = "0"
        DataInterpreterLocationY = "0"
        DataInterpreterOnTop = "False"
        TimeZone = "UTC"
        DetailsOnTop = "false"
        # Our custom overrides:
        Email = "."
        SubmitUnknown = "false"
    }

    $jsonString = $defaultConfig | ConvertTo-Json -Compress

    New-Item -Path $settingsPath -ItemType File -Value $jsonString -Force | Out-Null
}
