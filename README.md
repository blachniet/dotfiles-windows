# Brian's Windows dotfiles

## Prerequisites

- [ConEmu](https://conemu.github.io/)
- [Git](https://git-scm.com/)
- [Visual Studio Code](https://code.visualstudio.com/)
- Familiarity with [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)

## Getting started

```powershell
# Create the XDG configuration directory if it doesn't already exist
PS> New-Item -ItemType Directory ~/.config/
PS> cd ~/.config/

# Clone this repo
PS> git clone https://github.com/blachniet/dotfiles-windows.git

# Review the contents of ensure.ps1 before running!
PS> ./ensure.ps1
```

## Details

### PowerShell

The configuration for both types of PowerShell (Windows & Core) are shared. This probably won't work forever, but I'm leaving it this way for as long as I can.

Put local-only (not shared) PowerShell profile customizations in
- Windows PowerShell: `~/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.local.ps1`
- PowerShell: `~/Documents/PowerShell/Microsoft.PowerShell_profile.local.ps1`
