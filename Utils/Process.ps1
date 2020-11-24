function Execute-Command ($FilePath, $ArgumentList, $WorkingDirectory)
{
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $FilePath
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = $ArgumentList
    $pinfo.WorkingDirectory = $WorkingDirectory
    $pinfo.CreateNoWindow = $true

    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    $p.WaitForExit()

    [pscustomobject]@{
        StandardOutput = $p.StandardOutput.ReadToEnd()
        StandardError = $p.StandardError.ReadToEnd()
        ExitCode = $p.ExitCode
    }
}

function Execute-CommandWithInput ($FilePath, $ArgumentList, $StdInput, $WorkingDirectory)
{
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $FilePath
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.RedirectStandardInput = $true
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = $ArgumentList
    $pinfo.WorkingDirectory = $WorkingDirectory
    $pinfo.CreateNoWindow = $true

    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start()
      
    $p.StandardInput.WriteLine($StdInput)
    $p.StandardInput.Close()
    
    $p.WaitForExit()

    [pscustomobject]@{
        StandardOutput = $p.StandardOutput.ReadToEnd()
        StandardError = $p.StandardError.ReadToEnd()
        ExitCode = $p.ExitCode
    }
}