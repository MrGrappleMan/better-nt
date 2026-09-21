# Starter script

# Check for root else retry
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "Not running as administrator, please accept the UAC prompt that appears soon"
        Start-Sleep -Seconds 6
        try {
            # Attempt to relaunch as Admin
            Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"Invoke-Expression (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/user/repo/main/start.ps1' -UseBasicParsing).Content`""
            exit
        }
        catch {
            # If user disagrees, run this
            Write-Host "Admin rights not granted, you may not have the necessary permissions to proceed" -ForegroundColor Red
            Start-Sleep -Seconds 3
            exit
        }
    }
    catch {
        # If user disagrees, run this
        Write-Host "Admin rights not granted, you may not have the necessary permissions to proceed" -ForegroundColor Red
        Start-Sleep -Seconds 3
        exit
    }
}

# Install Git
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        winget install --id Git.Git -e --source winget
        # Refresh env vars
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path", "User")

        # Stop if git installation fails
        if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
            Write-Host "git installation failed. Exiting..." -ForegroundColor Red
            exit
        }
    }

# Repo actions
    $path = "$env:windir\Temp\windosill"
    if (Test-Path $path) { Remove-Item $path -Recurse -Force } # Delete existing repo
    New-Item -Path $path -ItemType Directory -Force | Out-Null # Remake repo folder
    git clone https://github.com/MrGrappleMan/windosill.git $path # Clone repo
    Set-Location $path # Set location to repo folder

# Copy to system drive
    robocopy .\fsroot $env:systemdrive /E

# Start main script
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$path\script\main.ps1`"" -Verb RunAs
