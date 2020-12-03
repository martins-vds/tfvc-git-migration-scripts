. .\Utils\Git.ps1

function Cleanup-GitTfs([System.IO.FileInfo]$RepoDirectory){
    Execute-GitTfs -ArgumentList "cleanup" -RepoDirectory $RepoDirectory
}

function Get-GitTfsConfigs([System.IO.FileInfo]$RepoDirectory) {
    Get-GitConfigs -NamePattern "tfs" -RepoDirectory $RepoDirectory
}

function Init-GitTfs ([System.Uri] $TfsUrl, [string] $TfsRepoPath, [System.IO.FileInfo] $IgnoreFile, [System.IO.FileInfo]$RepoDirectory) {
    Execute-GitTfs -ArgumentList "init --autocrlf=true --gitignore=""$IgnoreFile"" $TfsUrl ""$TfsRepoPath""" -RepoDirectory $RepoDirectory
}

function Pull-GitTfs {
    param (
        [Parameter(Mandatory = $true)]
        [ValidatePattern("^\d+$")]
        [string] $Changeset,
        [Parameter()]
        [System.IO.FileInfo] $IgnoreFile,
        [Parameter()]
        [System.IO.FileInfo] $RepoDirectory
    )

    Execute-GitTfs -ArgumentList "pull -c $($Changeset) --gitignore=$IgnoreFile" -RepoDirectory $RepoDirectory
    
    Copy-Item -Path $IgnoreFile -Destination $RepoDirectory -Force
    Rename-Item -Path $RepoDirectory\$($IgnoreFile.Name) -NewName ".gitignore"
    
    Stage-File -File ".gitignore" -RepoDirectory $RepoDirectory
}

function Remove-GitTfsConfigs([System.IO.FileInfo]$RepoDirectory){
    Remove-GitConfigs -NamePattern "tfs" -RepoDirectory $RepoDirectory

    $branches = List-Branches -RepoDirectory $RepoDirectory -Remote $true

    $branches | Where-Object { $_ -like "tfs/*" } | ForEach-Object { Delete-Branch -Branch $_ -RepoDirectory $RepoDirectory -Remote $true }
}

function Execute-GitTfs([string]$ArgumentList, [System.IO.FileInfo]$RepoDirectory) {
    $cmd = $null

    try {
        $cmd = Execute-Command -FilePath "git" -ArgumentList "tfs $ArgumentList" -WorkingDirectory $RepoDirectory
    }
    catch {
        throw $_.ErrorDetails
    }

    if ($cmd.ExitCode -gt 0) {
        throw "$($cmd.StandardError)"
    }
}