# Brian's Windows dotfiles

```powershell
PS> New-Item -ItemType Directory ~/.config/dotfiles-windows
PS> cd ~/.config/dotfiles-windows

# Review the contents of init.ps1 before running!
PS> ./init.ps1
```

## PowerShell

The configuration for both types of PowerShell (Windows & Core) are shared. This probably won't work forever, but I'm leaving it this way for as long as I can.

Put local-only (not shared) PowerShell profile customizations in
- Windows PowerShell: `~/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.local.ps1`
- PowerShell: `~/Documents/PowerShell/Microsoft.PowerShell_profile.local.ps1`
