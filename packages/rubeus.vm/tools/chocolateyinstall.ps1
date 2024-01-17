$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Rubeus'
$category = 'Credential Access'

$zipUrl = 'https://codeload.github.com/GhostPack/Rubeus/zip/baf34c7dcffb37cb96c92e402bab389229f1ec35'
$zipSha256 = 'a857b776e8f86a8f94da74beb6449fede16286aba129373a9899641aab078390'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
