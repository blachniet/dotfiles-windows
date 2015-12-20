$chocoCmd = (Get-Command "choco" -ErrorAction SilentlyContinue | Select-Object Definition )
if ($chocoCmd -eq $null) {
  iex ((New-Object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
}

Stop-Process -Name ssh-agent -Force -ErrorAction SilentlyContinue

choco install git -params "/GitOnlyOnPath" -y
choco install 7zip -y
choco install conemu -y
choco install fiddler4 -y
choco install golang -y
choco install google-chrome-x64 -y
choco install hg -y
choco install hxd -y
choco install malwarebytes -y
choco install nodejs -y
choco install python2 -y
choco install spf13-vim -y
choco install sqlite -y
choco install sqlitebrowser -y
choco install vagrant -y
choco install vim -y
choco install virtualbox
choco install virtualclonedrive -y
