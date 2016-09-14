param(
    [Parameter()]
    [string] $Dir = $null,
    [Parameter()]
    [string] $Target = $null,
    [Parameter(Mandatory=1,Position=0)]
    [string] $Package
)
$ErrorActionPreference = "Stop"

if (!$Dir){
    $Dir = (pwd).Path
}
if (!$Target){
    $Target = (Split-Path -Parent $Dir)
}
$pkgPath = Join-Path $Dir $Package

# Check to ensure there are no collisions
$collision = $false
ls $pkgPath | % {
    $destPath = Join-Path $Target $_.Name
    if (Test-Path $destPath){
        $collision = $true
        Write-Warning "Item already exists in target directory: $destPath"
    }
}
if ($collision){
    Write-Error "Operation cancelled because collisions in the target directory were found."
}

ls $pkgPath | % {
    $destPath = Join-Path $Target $_.Name
    Write-Debug $destPath
    if ($_.PSIsContainer){
        iex "cmd /c mklink /J `"$destPath`" `"$($_.FullName)`""
    } else {
        iex "cmd /c mklink /H `"$destPath`" `"$($_.FullName)`""
    }
}
