Invoke-Expression (& { (zoxide init powershell | Out-String) })
function HJ-Zip {
     param (
        [string[]]$Folders = @("*")
    )

    $resolvedFolders = @()

    foreach ($pattern in $Folders) {
        # Expand wildcards to actual directories
        $matches = Get-ChildItem -Directory -Path (Get-Location) -Filter $pattern -ErrorAction SilentlyContinue
        if ($matches) {
            $resolvedFolders += $matches.FullName
        }
        elseif (Test-Path $pattern -PathType Container) {
            # Direct path provided
            $resolvedFolders += (Resolve-Path $pattern).Path
        }
        else {
            Write-Warning "No folders matched pattern: $pattern"
        }
    }

    if (-not $resolvedFolders) {
        Write-Warning "No valid folders found to zip."
        return
    }

    foreach ($folder in $resolvedFolders | Sort-Object -Unique) {
        $folderName = Split-Path $folder -Leaf
        $zipPath = Join-Path (Get-Location) "$folderName.zip"

        if (Test-Path $zipPath) { Remove-Item $zipPath -Force }

        $tempPath = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString())
        New-Item -ItemType Directory -Path $tempPath | Out-Null

        # Copy only contents (not the folder itself)
        Get-ChildItem -Path $folder | ForEach-Object {
            Copy-Item -Path $_.FullName -Destination $tempPath -Recurse
        }

        Compress-Archive -Path (Join-Path $tempPath '*') -DestinationPath $zipPath
        Remove-Item $tempPath -Recurse -Force

        Write-Host "Created: $zipPath"
    }
}

function HJ-Sha256 {
    param (
        [string]$Path = (Get-Location)
    )

    Get-ChildItem -Path $Path -Filter "*.zip" | ForEach-Object {
        $hash = Get-FileHash -Algorithm SHA256 -Path $_.FullName
        [PSCustomObject]@{
            File = $_.Name
            SHA256 = $hash.Hash
        }
    }
}

function HJ-ver {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    if (!(Test-Path $Path)) {
        Write-Error "❌ File not found: $Path"
        return
    }

    $info = (Get-Item $Path).VersionInfo

    [PSCustomObject]@{
        File           = $Path
        RawVersion     = $info.FileMajorPart.ToString() + "." +
                         $info.FileMinorPart.ToString() + "." +
                         $info.FileBuildPart.ToString() + "." +
                         $info.FilePrivatePart.ToString()
    }
}


$env:Path += ";C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin"

function npp {
    param(
        [Parameter(Mandatory = $false)]
        [string]$SourceFile,

        [Parameter(Mandatory = $false)]
        [string]$DestinationPath
    )

    if (-not $SourceFile) {
        $SourceFile = Read-Host "Enter source DLL path"
    }
    if (-not $DestinationPath) {
        $DestinationPath = Read-Host "Enter destination folder path"
    }

    while ($true) {
        $input = Read-Host "Copy (Y/N)"
        
        if ($input -in @('Y','y','')) {

            try {
                if (!(Test-Path $SourceFile)) {
                    Write-Error "Source file not found: $SourceFile"
                    return
                }

                if (!(Test-Path $DestinationPath)) {
                    Write-Verbose "Destination path does not exist. Creating directory: $DestinationPath"
                    New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null
                }

                $destinationFile = Join-Path $DestinationPath (Split-Path $SourceFile -Leaf)

                Copy-Item -Path $SourceFile -Destination $destinationFile -Force
                Write-Output "File copied successfully to $destinationFile"
            }
            catch {
                Write-Error "Error copying file: $_"
            }
        }
        elseif ($input -in @('N','n')) {
            Write-Output "Exiting."
            break
        }
        else {
            Write-Warning "Invalid input. Type Y or N."
        }
    }
}
