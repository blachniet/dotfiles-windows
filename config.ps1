[CmdletBinding()]
param()

. $PSScriptRoot/dsl.ps1

$c = DotfilesConfiguration {
    ##########
    # Dotfiles
    ##########
    EnvironmentVariable "DOTFILES_HOME" `
        -VariableName "DOTFILES_HOME" `
        -VariableValue "$PSScriptRoot" `
        -Target User

    ##########
    # XDG
    ##########
    Directory "XDG Local Dir" `
        -Path "$HOME\.local" `
        -Hidden
    Directory "XDG_DATA_HOME Dir" `
        -Path "$HOME\.local\share"
    EnvironmentVariable "XDG_DATA_HOME" `
        -VariableName "XDG_DATA_HOME" `
        -VariableValue "$HOME\.local\share" `
        -Target User
    Directory "XDG_CONFIG_HOME Dir" `
        -Path "$HOME\.config" `
        -Hidden
    EnvironmentVariable "XDG_CONFIG_HOME" `
        -VariableName "XDG_CONFIG_HOME" `
        -VariableValue "$HOME\.config" `
        -Target User
    Directory "XDG_CACHE_HOME Dir" `
        -Path "$HOME\.cache" `
        -Hidden
    EnvironmentVariable "XDG_CACHE_HOME" `
        -VariableName "XDG_CACHE_HOME" `
        -VariableValue "$HOME\.cache" `
        -Target User

    ##########
    # Go
    ##########
    EnvironmentVariable "GOPATH" `
        -VariableName "GOPATH" `
        -VariableValue "$HOME\go" `
        -Target User

    ##########
    # Git
    ##########
    Directory "GitConfigDir" `
        -Path "$HOME\.config\git"
    # TODO: Ensure extra git file mentioned. Should I add a recurse option to directory?

    ##########
    # Windows PowerShell
    ##########
    Directory "WindowsPowerShellDir" `
        -Path "$HOME\Documents\WindowsPowerShell"
    File "WindowsPowerShellProfile" `
        -SourcePath "$PSScriptRoot\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" `
        -DestinationPath "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

    ##########
    # PowerShell (pwsh)
    ##########
    # I'm re-using the Windows PowerShell profile for PowerShell. This probably won't work
    # forever, but it's fine for now.
    Directory "PowerShellDir" `
        -Path "$HOME\Documents\PowerShell"
    File "PowerShellProfile" `
        -SourcePath "$PSScriptRoot\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" `
        -DestinationPath "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

    ##########
    # Visual Studio Code
    ##########
    Directory "VSCodeDir" `
        -Path "$HOME\AppData\Roaming\Code\User"
    File "VSCodeSettings" `
        -SourcePath "$PSScriptRoot\VisualStudioCode\settings.json" `
        -DestinationPath "$HOME\AppData\Roaming\Code\User\settings.json"

    ##########
    # ConEmu
    ##########
    File "ConEmuSettings" `
        -SourcePath "$PSScriptRoot\conemu\ConeEmu.xml" `
        -DestinationPath "$HOME\AppData\Roaming\ConEmu.xml"

    # TODO: Scheduled Task for testing status of dotfiles
}

Test-DotfilesConfiguration $c