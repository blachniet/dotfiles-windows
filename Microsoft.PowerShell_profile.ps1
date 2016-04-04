########################################
# Aliases
########################################
Set-Alias dockerc   'C:\Program Files\Docker Toolbox\docker-compose.exe'
Set-Alias dockerm   'C:\Program Files\Docker Toolbox\docker-machine.exe'
Set-Alias ssh-agent 'C:\Program Files\Git\usr\bin\ssh-agent.exe'
Set-Alias subl      'C:\Program Files\Sublime Text 3\subl.exe'
Set-Alias sublime   'C:\Program Files\Sublime Text 3\sublime_text.exe'
Set-Alias vpncli    'C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpncli.exe'

########################################
# Functions
########################################
function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }
function touch($file) { "" | Out-File $file -Encoding ASCII }
function mklink { cmd /c mklink $args }

Push-Location (Split-Path -Parent $PROFILE)
"extras" | ? {Test-Path "$_.ps1"} | % { iex ". .\$_.ps1"}
Pop-Location

$env:GOPATH = "$HOME/Developer/Go"
$env:PATH += ";$env:GOPATH/bin"
$env:PATH += ";$(Join-Path (Split-Path -Parent $PROFILE) 'Scripts')"

########################################
# posh-git
########################################
if ((Get-Module -ListAvailable -Name posh-git) -ne $null){
	Import-Module posh-git
	function global:prompt {
	    $realLASTEXITCODE = $LASTEXITCODE

	    Write-Host($pwd.ProviderPath) -nonewline

	    Write-VcsStatus

	    $global:LASTEXITCODE = $realLASTEXITCODE
	    return "> "
	}
	Start-SshAgent -Quiet
}
