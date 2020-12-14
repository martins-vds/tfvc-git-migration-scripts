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
    Write-Host "Initializing GitVersion..." -ForegroundColor White

    Copy-Item -Path .\GitVersion.yml -Destination $GitRepoDirectory -Force | Out-Null   
    Stage-File -File .\GitVersion.yml -RepoDirectory $GitRepoDirectory | Out-Null
    Create-Commit -Message "Added GitVersion" -RepoDirectory $GitRepoDirectory | Out-Null
    
    Write-Host "Successfully initialized GitVersion." -ForegroundColor Green
}
catch {
    Write-Error "Failed to initialize GitVersion. Reason: $($_)"
}