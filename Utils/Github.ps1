. .\Utils\Process.ps1

function Create-GithubRepo([string] $Name, [string]$Description, [string] $Team, [System.IO.FileInfo]$RepoDirectory){
    $argList = "repo create ""$Name"" --description ""$Description"" --confirm --private"
    
    if(![string]::IsNullOrWhiteSpace($Team)){
        $argList = $argList + "--team ""$Team"""
    }

    Execute-Github -ArgumentList $argList -RepoDirectory $RepoDirectory
}

function Login-Github([string] $Token, [System.IO.FileInfo]$RepoDirectory){
    Execute-Github -ArgumentList "auth login --with-token" -StdInput $Token -RepoDirectory $RepoDirectory
}

function Execute-Github([string]$ArgumentList, [System.IO.FileInfo]$RepoDirectory) {
    $cmd = $null

    try {
        $cmd = Execute-Command -FilePath "gh" -ArgumentList $ArgumentList -WorkingDirectory $RepoDirectory
    }
    catch {
        throw $_.ErrorDetails
    }

    if ($cmd.ExitCode -gt 0) {
        throw "$($cmd.StandardError)"
    }

    return $cmd
}

function Execute-Github([string]$ArgumentList, [string] $StdInput, [System.IO.FileInfo]$RepoDirectory) {
    $cmd = $null
    
    try {
        $cmd = Execute-CommandWithInput -FilePath "gh" -ArgumentList $ArgumentList -StdInput $StdInput -WorkingDirectory $RepoDirectory
    }
    catch {
        throw $_.ErrorDetails
    }

    if ($cmd.ExitCode -gt 0) {
        throw "$($cmd.StandardError)"
    }

    return $cmd
}