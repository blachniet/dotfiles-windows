########################################
# Variables
########################################
$PROFILE_HOME = (Split-Path $PROFILE)

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
function touch($Path) { New-Item -ItemType File $Path }
function rmrf($path) { Remove-Item -Recurse -Force $path }
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

function Get-AssemblyInfo {
	param(
		# Specifies a path to one or more locations.
		[Parameter(Mandatory=$true,
				   Position=0,
				   ValueFromPipeline=$true,
				   ValueFromPipelineByPropertyName=$true,
				   HelpMessage="Path to one or more locations.")]
		[Alias("PSPath")]
		[ValidateNotNullOrEmpty()]
		[string[]]
		$Path
	)

	$Path | Get-ChildItem | ForEach-Object {
		$assembly = [System.Reflection.Assembly]::ReflectionOnlyLoadFrom($_.FullName)
		$customAttrs = [System.Reflection.CustomAttributeData]::GetCustomAttributes($assembly)

		New-Object -TypeName PSObject -Property @{
			# FileVersion = $_.VersionInfo.FileVersion
			# ProductVersion = $_.VersionInfo.ProductVersion
			# FullAssemblyName = $assembly.FullName
			CustomAttributes = $customAttrs
			Assembly = $assembly
			VersionInfo = $_.VersionInfo
		}
	}
}

########################################
# Modules
########################################
Import-Module posh-git

########################################
# Local Customizations
# Generally, Microsoft.PowerShell_profile.local.ps1
########################################
$localProfile = Join-Path $PROFILE_HOME ((Get-Item $PROFILE).BaseName + ".local.ps1")
if (Test-Path $localProfile) {
    Invoke-Expression ". $localProfile"
}
