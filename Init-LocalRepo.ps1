[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [System.IO.FileInfo]$GitRepoDirectory,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [System.Uri] $TfsUrl,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()] 
    [string] $TfsRepoPath,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript( {
        if (-Not ($_ | Test-Path -PathType Leaf) ) {
            throw "The Path argument must be a file. Folder paths are not allowed."
        }

        return $true
    })]
    [System.IO.FileInfo] $IgnoreFile
)

. .\Utils\GitTfs.ps1

if (-Not (Test-Path -Path $GitRepoDirectory)) {
    New-Item -Path $GitRepoDirectory -Type Directory | Out-Null
}

try {
    Write-Host "Initializing local git repo..." -ForegroundColor White

    Init-GitTfs -TfsUrl $TfsUrl -TfsRepoPath $TfsRepoPath -IgnoreFile $IgnoreFile -RepoDirectory $GitRepoDirectory | Out-Null
    
    Write-Host "Successfully initialized local git repo." -ForegroundColor Green
}
catch {
    Cleanup-GitTfs -RepoDirectory $GitRepoDirectory | Out-Null
    Remove-GitTfsConfigs -RepoDirectory $GitRepoDirectory | Out-Null
    
    Write-Error "Failed to initialize local git repo. Reason: $($_)"
}

