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

. .\Utils\GitTfs.ps1

# $tfsConfigs = Get-GitTfsConfigs -RepoDirectory $GitRepoDirectory

# if($tfsConfigs.Count -lt 7){
#     Write-Error "Failed to fetch from TFS. Reason: The repo '$($GitRepoDirectory.Name)' has not been properly initialized."
#     Exit
# }

function Remove-ReadOnlyAttribute ([System.IO.FileInfo] $RepoDirectory) {
    Get-ChildItem -Path $RepoDirectory -File -Exclude .\.git -Recurse | ForEach-Object {
        $_.IsReadOnly = $false
    }
}

Measure-Command {
    try {
        Write-Host "Pulling from TFS..." -ForegroundColor White

        Pull-GitTfs -Changeset $Changeset -RepoDirectory $GitRepoDirectory | Out-Null

        Write-Host "Successfully pulled from TFS." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to pull from TFS. Reason: $($_)"
        return
    }

    try {
        Write-Host "Removing read-only attribute from files..." -ForegroundColor White

        Remove-ReadOnlyAttribute -RepoDirectory $GitRepoDirectory

        Write-Host "Successfully removed read-only attributes." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to remove read-only attribute from files. Reason: $($_)"
        return
    }
}