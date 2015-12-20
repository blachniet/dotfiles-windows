$npmCmd = (Get-Command "npm" -ErrorAction SilentlyContinue | Select-Object Definition )
if ($npmCmd -eq $null){
  throw "NPM not installed."
}

npm install -g bower
npm install -g gulp
