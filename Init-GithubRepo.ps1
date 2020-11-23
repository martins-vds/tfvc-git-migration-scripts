[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [System.IO.FileInfo]$GitRepoDirectory,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Token,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Name,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Description,
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Team
)

. .\Utils\Github.ps1

if (-Not (Test-Path -Path $GitRepoDirectory)) {
    New-Item -Path $GitRepoDirectory -Type Directory | Out-Null
}

try {
    Login-Github -Token $Token -RepoDirectory $GitRepoDirectory

    Create-GithubRepo -Name $Name -Description $Description -Team $Team -RepoDirectory $GitRepoDirectory
    
    Write-Host "Successfully created Github repo." -ForegroundColor Green
}
catch {
    # Remove-GitSVNConfigs -RepoDirectory $GitRepoDirectory    
    Write-Error "Failed to create Github repo. Reason: $($_)"
}