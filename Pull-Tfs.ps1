[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidatePattern("^\d+$")]
    [string]$Changeset,
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

# $svnConfigs = Get-GitSVNConfigs -RepoDirectory $GitRepoDirectory

# if($svnConfigs.Count -lt 4){
#     Write-Error "Failed to fetch from TFS. Reason: The repo '$($GitRepoDirectory.Name)' has not been properly initialized."
#     Exit
# }

Measure-Command {
    try {
        Fetch-GitTfs -Changeset $Changeset -RepoDirectory $GitRepoDirectory

        Write-Host "Pull succeeded." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to pull from TFS. Reason: $($_)"
    }
}