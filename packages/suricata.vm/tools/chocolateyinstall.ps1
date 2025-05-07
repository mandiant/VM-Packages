$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking
Import-Module powershell-yaml

# set configurations
$toolName = "Suricata"
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$filetype = "MSI"
$toolDir = Join-Path ${Env:ProgramFiles} $toolName
$executablePath = Join-Path $toolDir "suricata.exe"
$url = "https://www.openinfosecfoundation.org/download/windows/Suricata-7.0.10-1-64bit.msi"
$sha256 = "b32a6ca8a793a603a23de307c83831c874099f50bbcd2710ee8325d69a49fb44"
$silentArgs = "/qn /norestart"

$packageArgs = @{
    toolName = $toolName
    category = $category
    filetype = $filetype
    silentArgs = $silentArgs
    executablePath = $executablePath
    url = $url
    sha256 = $sha256
    consoleApp = $true
}

# download msi file
VM-Install-With-Installer @packageArgs
VM-Assert-Path $executablePath

# delete default desktop shortcut
try{
    $desktopShortcutPath = "${Env:HomeDrive}\Users\*\Desktop\$toolName*.lnk"
    Remove-Item -Path $desktopShortcutPath -ErrorAction SilentlyContinue
}
catch{
    VM-Write-Log-Exception $_
}

# rules configuration and download
$rulesXmlPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)/rules.xml"
$rulesXml = [xml](Get-Content $rulesXmlPath)

$rulesDir = Join-Path $toolDir "rules" -Resolve
$rulesConfigPath = Join-Path $toolDir "suricata.yaml" -Resolve

$rulesConfig = ConvertFrom-Yaml (Get-Content -Raw -Path $rulesConfigPath)

$failures = @()
$rules = $rulesXml.rules.rule

$tempToolDir = Join-Path ${Env:TEMP} $toolName
$tempToolDir += ".vm"
$tempRuleDir = Join-Path $tempToolDir "rules"

foreach ($rule in $rules) {

    Write-Host "[+] Attempting to install rule: $($rule.name)"

    $filePath = Join-Path $tempToolDir ([System.IO.Path]::GetFileName($rule.url))

    try{
        Invoke-WebRequest -Uri $rule.url -OutFile $filePath

        # If the file ends in .zip, unzip it
        if ($filePath -like '*.zip') {

            Write-Host "ZIP file detected."

            Get-ChocolateyUnzip -FileFullPath $filePath -Destination $tempRuleDir

            #  if rules are present in innerFolder of zip archive
            if ($rule.innerFolder){
                $innerFolder = Join-Path $tempRuleDir $rule.innerFolder

                Get-ChildItem -Path $innerFolder -File | ForEach-Object {
                    Copy-Item -Path $_.FullName -Destination $tempRuleDir -Force
                }
            }

        } elseif ($filePath -like '*.rules') {

            Write-Host "Rules file detected. Moving to $tempRuleDir..."

            Move-Item -Path $filePath -Destination $tempRuleDir

        } else {
            throw "`t[!] Unsupported file type: '$filePath'. Only .zip and .rule are allowed."
        }
    } catch {
        $failures += $rule.name
    }
}

$allRuleFiles = Get-ChildItem -Path $tempRuleDir -Recurse -File -Filter *.rules

# move all rule files in temp rule folder to the suricata rule folder
# add rules to `suricata.yaml`
foreach ($ruleFile in $allRuleFiles){
    Move-Item -Path $ruleFile.FullName -Destination $rulesDir -Force
    if (-not ($rulesConfig.'rule-files' -contains $ruleFile.Name)){
        $rulesConfig.'rule-files' += $ruleFile.Name
    }
    Write-Host "`t[+] Rule $($ruleFile.Name) added to $rulesDir..."
}

$rulesConfig | ConvertTo-Yaml | Set-Content -Path $rulesConfigPath

# display all errors
if ($failures.Count -gt 0) {
    foreach ($module in $failures) {
        VM-Write-Log "ERROR" "Failed to install rule: $($rule.name)"
    }
    exit 1
}