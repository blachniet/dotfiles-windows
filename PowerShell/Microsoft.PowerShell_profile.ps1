########################################
# Aliases
########################################
Set-Alias dockerc   'C:\Program Files\Docker Toolbox\docker-compose.exe'
Set-Alias dockerm   'C:\Program Files\Docker Toolbox\docker-machine.exe'
Set-Alias scp       'C:\Program Files\Git\usr\bin\scp.exe'
Set-Alias ssh       'C:\Program Files\Git\usr\bin\ssh.exe'
Set-Alias ssh-add   'C:\Program Files\Git\usr\bin\ssh-add.exe'
Set-Alias ssh-agent 'C:\Program Files\Git\usr\bin\ssh-agent.exe'
Set-Alias vpncli    'C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpncli.exe'
Set-Alias meld      'C:\Program Files (x86)\Meld\Meld.exe'

########################################
# Functions
########################################
function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }
function touch($file) { "" | Out-File $file -Encoding ASCII }
function mklink { cmd /c mklink $args }
function rmrf($path) { rm -Recurse -Force $path }
function Update-NuGet {
	New-Item -Type Container -ErrorAction SilentlyContinue "$env:ProgramData\NuGet\"
	Invoke-WebRequest -Uri "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" -OutFile "$env:ProgramData\NuGet\nuget.exe"
}
function upd {
	param(
		[Parameter(Position=0)]
		[int] $Count = 1
	)
	if ($Count -gt 0) {
		$target = "../"
		for ($i = 1; $i -lt $Count; $i++) {
			$target = Join-Path $target "../"
		}
		Push-Location $target
	}
}

Push-Location (Split-Path -Parent $PROFILE)
"extras" | ? {Test-Path "$_.ps1"} | % { iex ". .\$_.ps1"}
Pop-Location

$env:GOPATH = "$HOME\Developer\Go"
$env:PATH += ";$env:GOPATH\bin"
$env:PATH += ";$(Join-Path (Split-Path -Parent $PROFILE) 'Scripts')"
