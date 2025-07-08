$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $tools = @(
        @{name = 'Word'; executable = 'WINWORD.EXE'},
        @{name = 'Excel'; executable = 'EXCEL.EXE'},
        @{name = 'PowerPoint'; executable = 'POWERPNT.EXE'},
        @{name = 'OneNote'; executable = 'ONENOTE.EXE'}
    )
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

    # Install with choco instead as dependency to provide params such the product
    choco install microsoft-office-deployment --params="'/DisableUpdate:TRUE  /Product:ProPlus2024Retail'" --no-progress

    # Find the directory where the tools are installed
    $officeDirectory = Resolve-Path "C:\Program Files**\Microsoft Office\root\Office16" | Select-Object -first 1

    # Ensure the tools are installed and create shortcuts
    forEach ($tool in $tools) {
        $executablePath = Join-Path $officeDirectory $($tool.executable) -Resolve
        VM-Install-Shortcut -toolName $tool.name -category $category -executablePath $executablePath
    }
} catch {
    VM-Write-Log-Exception $_
}
