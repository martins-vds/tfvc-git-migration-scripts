[CmdletBinding()]
param ( 
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
    Write-Host "Pushing local git repo to Github..." -ForegroundColor White

    Push-Git -RepoDirectory $GitRepoDirectory | Out-Null

    Write-Host "Successfully pushed local git repo to Github." -ForegroundColor Green
}
catch {
    Write-Error "Failed to push local git repo to Github. Reason: $($_)"
}