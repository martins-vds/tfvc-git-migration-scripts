[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High' )]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript( {
            if (-Not ($_ | Test-Path)) {
                throw "Path '$_' does not exit."
            }
        
            if (($_ | Test-Path -PathType Container)) {
                if (-Not ( $_ | Join-Path -ChildPath ".git" | Test-Path -PathType Container)) {
                    throw "Path '$_' is a valid git repository."
                }
            }
    
            return $true
        })]
    [System.IO.FileInfo]$GitRepoDirectory
)

. .\Utils\GitTfs.ps1

Write-Host "Cleaning up TFS related configs..." -ForegroundColor White

if ($PSCmdlet.ShouldProcess("TFS configs", "delete")) {
    Cleanup-GitTfs -RepoDirectory $GitRepoDirectory | Out-Null
    
    Remove-GitTfsConfigs -RepoDirectory $GitRepoDirectory | Out-Null

    Write-Host "Successfully cleaned up TFS related configs" -ForegroundColor Green
}else{
    Write-Warning "Operation aborted by user."
}