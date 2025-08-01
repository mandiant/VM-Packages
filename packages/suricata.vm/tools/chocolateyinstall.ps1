$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try{
    $toolName = 'suricata'
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)
    $toolDir = Join-Path ${Env:ProgramFiles} $toolName
    $executablePath = Join-Path $toolDir "$toolName.exe"
    $exeUrl = "https://www.openinfosecfoundation.org/download/windows/Suricata-7.0.10-1-64bit.msi"
    $sha256 = "b32a6ca8a793a603a23de307c83831c874099f50bbcd2710ee8325d69a49fb44"

    $packageArgs = @{
        toolName = $toolName
        category = $category
        filetype = "MSI"
        silentArgs = "/qn /norestart"
        executablePath = $executablePath
        url = $exeUrl
        sha256 = $sha256
        consoleApp = $true
    }

    VM-Install-With-Installer @packageArgs

    # Delete default desktop shortcut
    $desktopShortcutPath = "${Env:HomeDrive}\Users\*\Desktop\$toolName*.lnk"
    Remove-Item -Path $desktopShortcutPath -ErrorAction SilentlyContinue

    # Rules configuration and download
    $rulesXmlPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)/rules.xml"
    $rulesXml = [xml](Get-Content $rulesXmlPath)
    $rulesDir = Join-Path $toolDir "rules" -Resolve
    $rules = $rulesXml.rules.rule

    # Tempdir for rules been added
    # Rules are added to tempdir before been added to default rule folder as other default rules exist in default folder
    # Rules filenames are needed for adding to config files
    $tempToolDir = Join-Path ${Env:TEMP} "$toolName.vm"
    $tempRuleDir = Join-Path $tempToolDir "rules"

    foreach ($rule in $rules) {
        VM-Write-Log "INFO" "Attempting to install rule: $($rule.name)"
        $filePath = Join-Path $tempToolDir ([System.IO.Path]::GetFileName($rule.url))

        # Create rule specific temp folder
        $tempRuleSpecificFolder = Join-Path $tempRuleDir $rule.name
        New-Item $tempRuleSpecificFolder -ItemType Directory -Force
        try{
            Invoke-WebRequest -Uri $rule.url -OutFile $filePath -ErrorAction Stop
            # If the rule URL is a ZIP archive (collection of multiple rule files)
            if ($filePath -like '*.zip') {
                VM-Write-Log "INFO" "ZIP file detected."
                Get-ChocolateyUnzip -FileFullPath $filePath -Destination $tempRuleSpecificFolder | Out-Null

            # If the rule URL is one rules file
            } elseif ($filePath -like '*.rules') {
                VM-Write-Log "INFO" "Rules file detected. Moving to $tempRuleSpecificFolder..."
                Move-Item -Path $filePath -Destination $tempRuleSpecificFolder

            # Any other types of url resource is unsupported
            } else {
                throw "Unsupported file type: '$filePath'. Only .zip and .rule are allowed."
            }
        } catch {
            VM-Write-Log "WARN" "Failed rule: $filePath. Cause: $($_.Exception.Message)"
        }
    }

    $allRuleFiles = Get-ChildItem -Path $tempRuleDir -Recurse -File -Filter *.rules

    $rulesConfigPath = Join-Path $toolDir "suricata.yaml" -Resolve
    $rulesConfigLines = Get-Content -Path $rulesConfigPath

    # Index of the location in the yaml where `rule-files:` is specified
    # Also collect all rules references in the config file
    $ruleFilesIndex = $null
    $rulesList = @()
    for ($i = 0; $i -lt $rulesConfigLines.Count; $i++) {
        $line = $rulesConfigLines[$i].Trim()

        # Set ruleFilesIndex when `rule-files:` found
        if ($line -match '^rule-files:$') {
            $ruleFilesIndex = $i
            continue
        }

        # Only when `rule-files` found, collect the rules references
        if ($null -ne $ruleFilesIndex){

            # Break rules reference search if the line does not start with '- .*'
            if ($line -notmatch "- .*"){
                break
            }
            else{
                if ($line -match '\.rules$'){
                    $cleanLine = $line.TrimStart('- ')
                    $rulesList += $cleanLine
                }
            }
        }
    }

    # The config file must have `rule-files:`, throw an error if not found
    if ($null -eq $ruleFilesIndex) {
        throw "Line with 'rule-files:' string not found in the config file."
    }

    # Move all rule files in temp rule folder to the suricata rule folder
    # Add rules to `suricata.yaml`
    VM-Write-Log "INFO" "Moving rule-files to $rulesDir..."
    foreach ($ruleFile in $allRuleFiles){
        Move-Item -Path $ruleFile.FullName -Destination $rulesDir -Force
        if (-not ($rulesList -contains $ruleFile.Name)){
            $newRuleLine = " - $($ruleFile.Name)"
             # Add rule to config file
            $rulesConfigLines = $rulesConfigLines[0..$ruleFilesIndex] + $newRuleLine + $rulesConfigLines[($ruleFilesIndex + 1)..($rulesConfigLines.Length - 1)]
            VM-Write-Log "INFO" "[+] Rule-file $($ruleFile.Name) added to $rulesDir. Added rule-file reference to config file."
        }
        else{
            VM-Write-Log "INFO" "[+] Rule-file $($ruleFile.Name) added to $rulesDir. Rule-file reference already exist in config file."
        }
    }

    # Save the updated content back to the file
    $rulesConfigLines | Set-Content -Path $rulesConfigPath
}
catch{
    VM-Write-Log-Exception $_
}