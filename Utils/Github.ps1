. .\Utils\Process.ps1

function Create-GithubRepo([string] $Name, [string]$Description, [string] $Team, [System.IO.FileInfo]$RepoDirectory){
    $argList = "$Name --description $Description --confirm --private"
    
    if(![string]::IsNullOrWhiteSpace($Team)){
        $argList = $argList + "--team $Team"
    }

    $cmd = Execute-Github -ArgumentList $argList -RepoDirectory $RepoDirectory

    if ($cmd.ExitCode -gt 0) {
        throw "$($cmd.StandardError)"
    }
}

function Login-Github([string] $Token, [System.IO.FileInfo]$RepoDirectory){
    $cmd = Execute-Github -ArgumentList "auth login --with-token" -StdInput $Token -RepoDirectory $RepoDirectory

    if ($cmd.ExitCode -gt 0) {
        throw "$($cmd.StandardError)"
    }
}

function Execute-Github([string]$ArgumentList, [System.IO.FileInfo]$RepoDirectory) {
    Execute-Command -FilePath "gh" -ArgumentList $ArgumentList -WorkingDirectory $RepoDirectory
}

function Execute-Github([string]$ArgumentList, [string] $StdInput, [System.IO.FileInfo]$RepoDirectory) {
    Execute-CommandWithInput -FilePath "gh" -ArgumentList $ArgumentList -StdInput $StdInput -WorkingDirectory $RepoDirectory
}