[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [System.IO.FileInfo]$GitRepoDirectory,
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]  
    [ValidateScript( {
            if (-Not ($_ | Test-Path -PathType Leaf) ) {
                throw "The Path argument must be a file. Folder paths are not allowed."
            }

            return $true
        })]
    [System.IO.FileInfo]$AuthorsFile,
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
    [System.IO.FileInfo] $IgnoreFile,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [System.Uri] $TfsUrl
)

. .\Utils\Git.ps1

if (-Not (Test-Path -Path $GitRepoDirectory)) {
    New-Item -Path $GitRepoDirectory -Type Directory | Out-Null
}

try {
    Init-GitTfs -TfsUrl $TfsUrl -TfsRepoPath $TfsRepoPath -IgnoreFile $IgnoreFile -RepoDirectory $GitRepoDirectory
    
    Write-Host "Successfully initialized local git repo." -ForegroundColor Green
}
catch {
    # Remove-GitSVNConfigs -RepoDirectory $GitRepoDirectory    
    Write-Error "Failed to initialize local git repo. Reason: $($_)"
}

