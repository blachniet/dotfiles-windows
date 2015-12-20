if (Test-Path $PROFILE){
  mv $PROFILE "$PROFILE.$(Get-Date -f yyMMddhhmmss).old"
} else {
  New-Item -ItemType Container (Split-Path -Parent $PROFILE) -ErrorAction SilentlyContinue
}

iex "cmd /c mklink /H `"$PROFILE`" `"$(Join-Path $PSScriptRoot Microsoft.PowerShell_profile.ps1)`""
iex ". $PROFILE"

Push-Location $PSScriptRoot
"choco-install",
"npm-install",
"windows-config",
"git\symlink",
"atom\apm-install",
"atom\symlink" |
  ? {Test-Path "$_.ps1"} | % { iex ". .\$_.ps1"}
Pop-Location
