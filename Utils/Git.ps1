. .\Utils\Process.ps1

function Init-GitSVN ($Trunk, $Ignore, [System.Uri] $SvnUrl, [System.IO.FileInfo]$RepoDirectory) {
    $cmd = Execute-Git -ArgumentList "svn init --prefix=svn/ --trunk $Trunk --ignore-paths=""$Ignore"" $SvnUrl" -RepoDirectory $RepoDirectory
    if ($cmd.ExitCode -gt 0) {
        throw "$($cmd.StandardError)"
    }
}

function Init-GitTfs ([System.Uri] $TfsUrl, [string] $TfsRepoPath, [System.IO.FileInfo] $IgnoreFile, [System.IO.FileInfo]$RepoDirectory) {
    $cmd = Execute-Git -ArgumentList "tfs init --autocrlf=true --gitignore=""$IgnoreFile"" $TfsUrl ""$TfsRepoPath""" -RepoDirectory $RepoDirectory
    if ($cmd.ExitCode -gt 0) {
        throw "$($cmd.StandardError)"
    }
}

function Add-GitConfig ([string] $Name, [string] $Value, [System.IO.FileInfo]$RepoDirectory) {
    $cmd = Execute-Git -ArgumentList "config --add $Name ""$Value""" -RepoDirectory $RepoDirectory
    if ($cmd.ExitCode -gt 0) {
        throw "$($cmd.StandardError)"
    }
}

function Create-Branch ([string] $BaseBranch, [string] $NewBranch, [System.IO.FileInfo]$RepoDirectory) {
    $cmd = Execute-Git -ArgumentList "checkout $BaseBranch" -RepoDirectory $RepoDirectory
    
    if ($cmd.ExitCode -gt 0) {
        throw "$($cmd.StandardError)"
    }

    $cmd = Execute-Git -ArgumentList "branch $NewBranch" -RepoDirectory $RepoDirectory

    if ($cmd.ExitCode -gt 0) {
        throw "$($cmd.StandardError)"
    }
}

function Get-GitSVNConfigs([System.IO.FileInfo]$RepoDirectory) {
    Get-GitConfigs -NamePattern "^svn" -RepoDirectory $RepoDirectory
}

function Get-GitConfigs ([string] $NamePattern, [System.IO.FileInfo]$RepoDirectory) {
    $cmd = Execute-Git -ArgumentList "config --get-regexp ""$NamePattern""" -RepoDirectory $RepoDirectory

    if ($cmd.ExitCode -ge 1 -and -not [string]::IsNullOrWhiteSpace($cmd.StandardError)) {      
        throw "$($cmd.StandardError)"
    }

    $output = $cmd.StandardOutput

    $configs = @(
        if (![string]::IsNullOrWhiteSpace($output)) { 
            $output -split "\n" | ForEach-Object { 
                if (-not [string]::IsNullOrWhiteSpace($_)) {
                    $_.Split()[0]
                } 
            } | Sort-Object -Unique
        }
    )

    return $configs
}

function Remove-GitConfig ([string] $Config, [System.IO.FileInfo]$RepoDirectory) {
    $cmd = Execute-Git -ArgumentList "config --unset-all $Config" -RepoDirectory $RepoDirectory
    if ($cmd.ExitCode -gt 0) {
        throw "$($cmd.StandardError)"
    }
}

function Remove-GitSVNConfigs([System.IO.FileInfo]$RepoDirectory){
    Remove-GitConfigs -NamePattern "^svn" -RepoDirectory $RepoDirectory
}

function Remove-GitConfigs ([string] $NamePattern, [System.IO.FileInfo]$RepoDirectory) {
    $configs = Get-GitConfigs -NamePattern $NamePattern -RepoDirectory $RepoDirectory

    if ($configs.Count -gt 0) {
        $configs | ForEach-Object {
            If ($_ -ne "") {
                Remove-GitConfig -Config $_ -RepoDirectory $RepoDirectory
                Write-Information "Removed config '$_'"
            }    
        }
    }
    else {
        Write-Warning "No configs found. Nothing to remove."
    }
}

function Fetch-GitSVN {
    param (
        [Parameter(Mandatory = $true)]
        [ValidatePattern("^\d+$")]
        [string] $Revision,
        [Parameter()]
        [System.IO.FileInfo]$RepoDirectory
    )

    $cmd = Execute-Git -ArgumentList "svn fetch --log-window-size=100000 -r$($Revision):HEAD --no-follow-parent --quiet --quiet" -RepoDirectory $RepoDirectory

    if ($cmd.ExitCode -gt 0) {
        throw "$($cmd.StandardError)"
    }
}

function Fetch-GitTfs {
    param (
        [Parameter(Mandatory = $true)]
        [ValidatePattern("^\d+$")]
        [string] $Changeset,
        [Parameter()]
        [System.IO.FileInfo]$RepoDirectory
    )

    $cmd = Execute-Git -ArgumentList "tfs pull -c $($Changeset)" -RepoDirectory $RepoDirectory

    if ($cmd.ExitCode -gt 0) {
        throw "$($cmd.StandardError)"
    }
}

function Execute-Git([string]$ArgumentList, [System.IO.FileInfo]$RepoDirectory) {
    Execute-Command -FilePath "git" -ArgumentList $ArgumentList -WorkingDirectory $RepoDirectory
}