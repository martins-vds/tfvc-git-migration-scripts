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

$tfsConfigs = Get-GitTfsConfigs -RepoDirectory $GitRepoDirectory

if($tfsConfigs.Count -lt 7){
    Write-Error "Failed to fetch from TFS. Reason: The repo '$($GitRepoDirectory.Name)' has not been properly initialized."
    Exit
}

Measure-Command {
    try {
        Pull-GitTfs -Changeset $Changeset -RepoDirectory $GitRepoDirectory

        Write-Host "Pull succeeded." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to pull from TFS. Reason: $($_)"
    }
}