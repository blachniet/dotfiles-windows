[CmdletBinding()]
param(
)

function EnsureDir {
    param(
        [Parameter(Mandatory=1)]
        [string]
        $Path,
        [switch]
        $Hidden
    )

    Write-Host "[Directory] '$Path'" -ForegroundColor Green

    if (Test-Path $Path) {
        Write-Verbose "No action necessary - directory already exists."
    } else {
        New-Item -ItemType 'Directory' $Path

        if ($Hidden) {
            (Get-Item $Path).Attributes = 'Hidden'
        }
    }
}

function EnsureFile {
    param(
        [Parameter(Mandatory=1)]
        [string]
        $Path
    )

    Write-Host "[File] '$Path'" -ForegroundColor Green

    if (Test-Path $Path) {
        Write-Verbose "No action necessary - file already exists."
    } else {
        New-Item -ItemType 'File' $Path
    }
}

function EnsureEnvironmentVariable {
    param(
        [Parameter(Mandatory=1)]
        [string]
        $Name,
        [Parameter(Mandatory=1)]
        [string]
        $Value
    )

    Write-Host "[EnvironmentVariable] '$Name' = '$Value'" -ForegroundColor Green
    
    $originalValue = [System.Environment]::GetEnvironmentVariable("$Name", "User")

    if ([string]::IsNullOrEmpty($originalValue)) {
        [System.Environment]::SetEnvironmentVariable("$Name", "$Value", "User") | Out-Null
        Write-Verbose "Set environment variable '$Name' to '$Value'"
    } elseif ($originalValue -ne $Value) {
        Write-Error ("Did not set environment variable '$Name' to '$Value'. The envrionment" +
            " variable with that name already exists with another value, '$originalValue'." +
            " Delete that value and try again.")
    } else {
        Write-Verbose "No action necessary - environment variable already set to requested value."
    }
}

function EnsureHardLink {
    param (
        [Parameter(Mandatory=1)]
        [string]
        $Path,
        [Parameter(Mandatory=1)]
        [string]
        $Value
    )

    Write-Host "[HardLink] '$Path' --> '$Value'" -ForegroundColor Green

    $item = Get-Item $Path -ErrorAction SilentlyContinue

    if ($null -eq $item) {
        New-Item -ItemType HardLink -Path $Path -Value $Value
    } elseif (($item.LinkType -ne 'HardLink') -or ($Value -notin $item.Target)) {
        Write-Error ("Creating hard link failed because an item already exists at '$Path'." +
            " Remove the item at that path and try again.") 
    } else {
        Write-Verbose "No action necessary - hard link already exists."
    }
}

##########
# XDG
##########
EnsureEnvironmentVariable "DOTFILES_HOME" "$PSScriptRoot"

##########
# XDG
##########
EnsureDir "$HOME\.local" -Hidden
EnsureDir "$HOME\.local\share"
EnsureEnvironmentVariable "XDG_DATA_HOME" "$HOME\.local\share"
EnsureDir "$HOME\.config"
EnsureEnvironmentVariable "XDG_CONFIG_HOME" "$HOME\.config"
EnsureDir "$HOME\.cache"
EnsureEnvironmentVariable "XDG_CACHE_HOME" "$HOME\.cache"

##########
# Go
##########
EnsureEnvironmentVariable "GOPATH" "$HOME\go"

##########
# Git
##########

$userGitConfigPath = "$HOME\.config\git\config"
$dotfilesGitConfigPath = (Resolve-Path "$PSScriptRoot\git\config").Path.Replace('\', '/')

# Using XDG paths for Git. 
EnsureDir "$HOME\.config\git"
EnsureFile $userGitConfigPath

# Ensure the configuration in this repository is included in the user configuration file. If it is
# not, prepend it to the config file. See https://git-scm.com/docs/git-config#_includes
Write-Host "[Git] Include $dotfilesGitConfigPath" -ForegroundColor Green
$configContent = Get-Content -Raw $userGitConfigPath
if ([string]::IsNullOrEmpty($configContent) -or ($configContent.Contains("path = $dotfilesGitConfigPath") -eq $false)) {
    [System.IO.File]::WriteAllText(
        (Resolve-Path $userGitConfigPath).Path,
        "[include]`n`tpath = $dotfilesGitConfigPath`n$configContent")
}

##########
# Windows
##########

# Explorer: Show hidden files by default (1: Show Files, 2: Hide Files)
Write-Host "[Windows] Show hidden files" -ForegroundColor Green
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1

# Explorer: show file extensions by default (0: Show Extensions, 1: Hide Extensions)
Write-Host "[Windows] Show file extensions" -ForegroundColor Green
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0

##########
# Windows PowerShell
##########
EnsureDir "$HOME\Documents\WindowsPowerShell"
EnsureHardLink "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" "$PSScriptRoot\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

##########
# PowerShell (pwsh)
##########
# I'm re-using the Windows PowerShell profile for PowerShell. This probably won't work
# forever, but it's fine for now.
EnsureDir "$HOME\Documents\PowerShell"
EnsureHardLink "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" "$PSScriptRoot\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

##########
# Visual Studio Code
##########
EnsureDir "$HOME\AppData\Roaming\Code\User"
EnsureHardLink "$HOME\AppData\Roaming\Code\User\settings.json" "$PSScriptRoot\VisualStudioCode\settings.json"

##########
# ConEmu
##########
EnsureHardLink "$HOME\AppData\Roaming\ConEmu.xml" "$PSScriptRoot\conemu\ConEmu.xml"

##########
# Scheduled Task for Test-DotfilesStatus
##########
Write-Host "[ScheduledTask] Test-DotfilesStatus" -ForegroundColor Green
if ($null -eq (Get-ScheduledTask 'Test-DotfilesStatus' -ErrorAction SilentlyContinue)) {
    $action = New-ScheduledTaskAction 'powershell.exe' `
        -Argument "-WindowStyle Hidden -Noninteractive -Command Test-DotfilesStatus"
    $trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
    $settings = New-ScheduledTaskSettingsSet -StartWhenAvailable
    Register-ScheduledTask -TaskName 'Test-DotfilesStatus' -TaskPath 'dotfiles-windows' `
        -Action $action -Trigger $trigger -Settings $settings
}
