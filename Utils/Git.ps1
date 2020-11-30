. .\Utils\Process.ps1

function Add-GitConfig ([string] $Name, [string] $Value, [System.IO.FileInfo]$RepoDirectory) {
    Execute-Git -ArgumentList "config --add $Name ""$Value""" -RepoDirectory $RepoDirectory
}

function Stage-File([string] $File, [System.IO.FileInfo]$RepoDirectory){
    Execute-Git -ArgumentList "add $File" -RepoDirectory $RepoDirectory
}

function Create-Commit([string] $Message, [System.IO.FileInfo]$RepoDirectory){
    Execute-Git -ArgumentList "commit -m ""$Message""" -RepoDirectory $RepoDirectory
}

function Create-Tag([string] $Tag, [System.IO.FileInfo]$RepoDirectory){
    Execute-Git -ArgumentList "tag v$Tag" -RepoDirectory $RepoDirectory
}

function Create-Branch ([string] $BaseBranch, [string] $NewBranch, [System.IO.FileInfo]$RepoDirectory) {
    Execute-Git -ArgumentList "checkout $BaseBranch" -RepoDirectory $RepoDirectory
    Execute-Git -ArgumentList "branch $NewBranch" -RepoDirectory $RepoDirectory
}

function List-Branches([System.IO.FileInfo]$RepoDirectory, [bool] $Remote = $false){
    if ($Remote) {
        $remoteArg = "-r"
    }else{
        $remoteArg = ""
    }
    
    $cmd = Execute-Git -ArgumentList "branch $remoteArg" -RepoDirectory $RepoDirectory

    $output = $cmd.StandardOutput

    $branches = @(
        if (![string]::IsNullOrWhiteSpace($output)) { 
            $output -split "\n" | ForEach-Object { 
                if (-not [string]::IsNullOrWhiteSpace($_)) {
                    $_.Trim()
                } 
            } | Sort-Object -Unique
        }
    )

    return $branches
}

function Delete-Branch ([string] $Branch, [System.IO.FileInfo]$RepoDirectory, [bool] $Remote = $false) {
    if ($Remote) {
        $remoteArg = "-r"
    }else{
        $remoteArg = ""
    }

    Execute-Git -ArgumentList "branch $remoteArg -D $Branch" -RepoDirectory $RepoDirectory
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
    Execute-Git -ArgumentList "config --unset-all $Config" -RepoDirectory $RepoDirectory
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

function Push-Git ([System.IO.FileInfo]$RepoDirectory) {
    Execute-Git -ArgumentList "push --all origin" -RepoDirectory $RepoDirectory
    Execute-Git -ArgumentList "push origin --tags" -RepoDirectory $RepoDirectory
}

function Run-GarbageCollection ([System.IO.FileInfo]$RepoDirectory) {
    Execute-Git -ArgumentList "gc --prune=all --aggressive" -RepoDirectory $RepoDirectory
}

function Execute-Git([string]$ArgumentList, [System.IO.FileInfo]$RepoDirectory) {
    $cmd = $null
    
    try {
        $cmd = Execute-Command -FilePath "git" -ArgumentList $ArgumentList -WorkingDirectory $RepoDirectory
    }
    catch {
        throw $_.ErrorDetails
    }

    if ($cmd.ExitCode -gt 0) {
        throw "$($cmd.StandardError)"
    }

    return $cmd
}