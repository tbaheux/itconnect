# You should put this file in the $profile.CurrentUserAllHosts path.
    # Linux                         : /home/<user>/.config/powershell/profile.ps1
    # Windows PowerShell 5.1        : C:\Users\<user>\Documents\WindowsPowerShell\profile.ps1
    # Windows PowerShell Core (7+)  : C:\Users\<user>\Documents\PowerShell\profile.ps1

    function Prompt {
        
    $CurrentUser = (Get-ChildItem Env:\USERNAME).Value
    $Hostname = hostname
    $CurrentPath = (Get-Location)
    $CurrentDirName = "./" + (Split-Path -Path $CurrentPath -Leaf)
        # ($CurrentPath.ToString() -Split {$_ -eq "/" -or $_ -eq "\"})[-1]
    $GitFolder = Join-Path -Path $CurrentPath -ChildPath ".git"
    $LastCommand = Get-History -Count 1
    if ($lastCommand) {
        $RunTime = ($lastCommand.EndExecutionTime - $lastCommand.StartExecutionTime).TotalSeconds
    }
    if ($RunTime -ge 60) {
        $ts = [timespan]::fromseconds($RunTime)
        $min, $sec = ($ts.ToString("mm\:ss")).Split(":")
        $ElapsedTime = -join ($min, " min ", $sec, " sec")
    }
    else {
        $ElapsedTime = [math]::Round(($RunTime), 2)
        $ElapsedTime = -join (($ElapsedTime.ToString()), " sec")
    }

    if (Test-Path $GitFolder) {
        $CurrentBranchExt = $((git branch) -match "\*");
        if ($CurrentBranchExt) {
            Try {			
                # Holds the pattern for extracting the branch name
                $CurrentBranchMatchPattern = "\w*";
                # Executes the regular expression against the matched branch
                $CurrentBranchNameMatches = [regex]::matches($CurrentBranchExt, $CurrentBranchMatchPattern);
                # Gets the current branch from the matches
                $CurrentBranchName = $CurrentBranchNameMatches.Captures[2].Value.Trim();

                # Sets the Prompt which contains the Current git branch name
                # Prompt format - current_directory [ current_branch ] >
                $GitPrompt = "($CurrentBranchName)" 			
            }
            Catch {
                # Default prompt
                $GitPompt = ""
            }
        } else {
            # Default prompt
            $GitPompt = ""
        }
    }
    else {$GitPrompt = ""}

    if ($IsWindows) {
        $IsAdmin = (New-Object Security.Principal.WindowsPrincipal `
        ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
        Write-Host ($(if ($IsAdmin) { 'Elevated ' } else { '' })) `
            -NoNewLine `
            -ForegroundColor White `
            -BackgroundColor DarkRed
    }
    elseif ($IsLinux -or $IsMacOS) {
        Write-Host "Sudo " `
        -NoNewLine `
        -ForegroundColor White `
        -BackgroundColor DarkRed
    }
    else {
        Write-Host "Desktop" `
            -NoNewLine `
            -ForegroundColor White `
            -BackgroundColor DarkRed
    }
    Write-Host " $CurrentUser@$Hostname " `
        -NoNewLine `
        -ForegroundColor White `
        -BackgroundColor DarkBlue
    Write-Host $CurrentDirName `
        -NoNewLine `
        -ForegroundColor White `
        -BackgroundColor Black
    Write-Host " $GitPrompt " `
        -NoNewLine `
        -ForegroundColor Yellow `
        -BackgroundColor Black
        Write-Host "[$ElapsedTime] " `
        -NoNewLine `
        -ForegroundColor Green `
        -BackgroundColor Black
    Write-Host (Get-History).Count `
        -NoNewLine `
        -ForegroundColor White `
        -BackgroundColor Black
    Write-Host " >" `
        -NoNewLine `
        -ForegroundColor White `
        -BackgroundColor Black

    $host.UI.RawUI.WindowTitle = "Current Dir: $((Get-Location).Path)"
    Return " "
    }
