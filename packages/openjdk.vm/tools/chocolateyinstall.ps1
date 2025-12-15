$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  # Execute .jar files with javaw.exe by default
  $javaw_path = "$Env:ProgramFiles\OpenJDK\jdk-25\bin\javaw.exe"
  VM-Assert-Path $javaw_path
  cmd /c assoc .jar=jarfile
  cmd /c ftype jarfile=`"$javaw_path`" -jar `"%1`" %*
} catch {
    VM-Write-Log-Exception $_
}

