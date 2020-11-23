. .\Utils\Process.ps1

function Create-GithubRepo([string] $Name, [string]$Description, [string] $Team, [System.IO.FileInfo]$RepoDirectory){
    $cmd = Execute-Github -ArgumentList "$Name --description $Description --team $Team --confirm --private" -RepoDirectory $RepoDirectory

    if ($cmd.ExitCode -gt 0) {
        throw "$($cmd.StandardError)"
    }
}

function Login-Github([System.IO.FileInfo]$RepoDirectory){
    $cmd = Execute-Github -ArgumentList "auth login --web" -RepoDirectory $RepoDirectory

    if ($cmd.ExitCode -gt 0) {
        throw "$($cmd.StandardError)"
    }
}

function Execute-Github([string]$ArgumentList, [System.IO.FileInfo]$RepoDirectory) {
    Execute-Command -FilePath "gh" -ArgumentList $ArgumentList -WorkingDirectory $RepoDirectory
}