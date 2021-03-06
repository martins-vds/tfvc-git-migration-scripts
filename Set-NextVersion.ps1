[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidatePattern("^\d+(\.\d+){2,3}$")]
    [string]$NextVersion,
    [Parameter(Mandatory = $true)]
    [ValidateScript( {
            if ( -Not ($_ | Test-Path) ) {
                throw "Folder does not exist"
            }
            if (-Not ($_ | Test-Path -PathType Container) ) {
                throw "The Path argument must be a folder. File paths are not allowed."
            }
            return $true
        })]
    [System.IO.FileInfo]$GitRepoDirectory
)

. .\Utils\Git.ps1 

try {
    Write-Host "Setting the next version to $NextVersion..." -ForegroundColor White

    Create-Tag -Tag $NextVersion -RepoDirectory $GitRepoDirectory | Out-Null

    Write-Host "Successfully setted the next version." -ForegroundColor Green
}
catch {
    Write-Error "Failed to set next version. Reason: $($_)"
}