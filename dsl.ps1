function Directory {
    param(
        [Parameter(Mandatory=1,Position=1)]
        [string]
        $Name,

        [Parameter(Mandatory=1)]
        [string]
        $Path,

        [Parameter()]
        [switch]
        $Hidden
    )

    $data = [PSCustomObject]$PSBoundParameters

    $data.PSObject.TypeNames.Insert(0,"DirectoryResource")

    $data | Add-Member -Name ResourceTypeName -MemberType NoteProperty -Value "Directory"

    # Test Method
    $data | Add-Member -Name Test -MemberType ScriptMethod -Value ([scriptblock]{
        return Test-Path -PathType Container $this.Path
    })

    # Set Method
    $data | Add-member -Name Set -MemberType ScriptMethod -Value ([scriptblock]{
        if (!($this.Test())) {
            New-Item -ItemType Directory $this.Path

            if ($this.Hidden) {
                (Get-Item $this.Path).Attributes = 'Hidden'
            }
        }
    })

    return $data
}

function EnvironmentVariable {
    param(
        [Parameter(Mandatory=1,Position=1)]
        [string]
        $Name,

        [Parameter(Mandatory=1)]
        [string]
        $VariableName,

        [Parameter(Mandatory=1)]
        [string]
        $VariableValue,

        [Parameter(Mandatory=1)]
        [string]
        $Target
    )

    $data = [PSCustomObject]$PSBoundParameters

    $data.PSObject.TypeNames.Insert(0,"EnvironmentVariableResource")

    $data | Add-Member -Name ResourceTypeName -MemberType NoteProperty -Value "EnvironmentVariable"

    # Test Method
    $data | Add-Member -Name Test -MemberType ScriptMethod -Value ([scriptblock]{
        $curValue = [System.Environment]::GetEnvironmentVariable($this.VariableName, $this.Target)

        if (!($curValue -eq $this.VariableValue)) {
            Write-Verbose "Expected '$($this.VariableValue)' but was '$curValue'"
            return $false
        }

        return $true
    })

    # Set Method
    $data | Add-member -Name Set -MemberType ScriptMethod -Value ([scriptblock]{
        [System.Environment]::SetEnvironmentVariable(
            $this.VariableName, $this.VariableValue, $this.Target) | Out-Null
    })

    return $data
}

function File {
    param(
        # Name for this file resource
        [Parameter(Mandatory=1,Position=1)]
        [string]
        $Name,

        # Source path
        [Parameter(Mandatory=1)]
        [string]
        $SourcePath,

        # Destination path
        [Parameter(Mandatory=1)]
        [string]
        $DestinationPath
    )

    $data = [PSCustomObject]$PSBoundParameters

    $data.PSObject.TypeNames.Insert(0,"FileResource")

    $data | Add-Member -Name ResourceTypeName -MemberType NoteProperty -Value "File"

    # Test Method
    $data | Add-Member -Name Test -MemberType ScriptMethod -Value ([scriptblock]{
        $srcHash = (Get-FileHash -Algorithm SHA256 $this.SourcePath).Hash
        $dstHash = (Get-FileHash -Algorithm SHA256 $this.DestinationPath).Hash

        return $srcHash -eq $dstHash
    })

    # Set Method
    $data | Add-member -Name Set -MemberType ScriptMethod -Value ([scriptblock]{
        Copy-Item -Force $this.SourcePath $this.DestinationPath
    })

    return $data
}

function DotfilesConfiguration {
    [cmdletbinding()]
    param(
        [scriptblock]
        $Resources
    )

    $config = [PSCustomObject][ordered]@{
        PSTypeName = "DotfilesConfiguration"
    }
    $resItems = & $Resources
    $resItems | ForEach-Object {
        $config | Add-Member -Name $_.Name -MemberType NoteProperty -Value $_
    }

    return $config
}

function Test-DotfilesConfiguration {
    param(
        [PSTypeName("DotfilesConfiguration")]
        $Configuration
    )

    $result = $true

    $Configuration.PSObject.Properties | ForEach-Object {
        $resTypeName = $_.Value.ResourceTypeName.PadRight(20)

        if (!($_.Value.Test())) {
            $result = $false
            Write-Host "[X] [$($resTypeName)] $($_.Value.Name)" -ForegroundColor Red
        } else {
            Write-Host "[$([Char]8730)] [$($resTypeName)] $($_.Value.Name)" -ForegroundColor Green
        }
    }

    return $result
}

function Set-DotfilesConfiguration {
    param(
        [PSTypeName("DotfilesConfiguration")]
        $Configuration
    )

    $Configuration.PSObject.Properties | ForEach-Object {
        $resTypeName = $_.Value.ResourceTypeName.PadRight(20)
        Write-Host "[$($resTypeName)] $($_.Value.Name)"
        $_.Value.Set()
    }
}
