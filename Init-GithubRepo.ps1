[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [System.IO.FileInfo]$GitRepoDirectory,
    [Parameter(Mandatory = $true)]
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

. .\Utils\Github.ps1

try {
    Login-Github -RepoDirectory $GitRepoDirectory

    Create-GithubRepo -Name $Name -Description $Description -Team $Team -RepoDirectory $GitRepoDirectory
    
    Write-Host "Successfully created Github repo." -ForegroundColor Green
}
catch {
    # Remove-GitSVNConfigs -RepoDirectory $GitRepoDirectory    
    Write-Error "Failed to create Github repo. Reason: $($_)"
}