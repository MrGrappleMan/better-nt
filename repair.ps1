# All in one system repair script utilising Microsoft's built-in repair tools
# Run this only when you are experiencing issues with your system

# Check if running as administrator
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "Not running as administrator, please try again with Ctrl + Shift + Enter"
        Start-Sleep -Seconds 3
        #powershell irm https://raw.githubusercontent.com/MrGrappleMan/windosill/main/repair.ps1 | iex
        # Want to implement self elevation method here, ofcourse respecting user choice
        exit
    }

# Maintain system files integrity
    sfc /scannow

# Checks disk for errors and attempts to fix file system errors (/f) and bad sectors (/r)
    chkdsk /f /r

# Checks the health of the Windows Component Store for corruption
    dism /Online /CheckHealth

# Performs a more thorough scan of the Windows Component Store for corruption
    dism /Online /ScanHealth

# Repairs the Windows Component Store by restoring corrupted files from an online source
    dism /Online /Cleanup-Image /RestoreHealth

# Resync with NTP servers and rediscover time sources
    w32tm /resync /rediscover

# Networking
    # Get new IPv4 address from DHCP server
        ipconfig /release
        ipconfig /renew
    # Get new IPv6 address from DHCP server
        ipconfig /release6
        ipconfig /renew6
    # Clears the DNS resolver cache to resolve DNS-related issues
        ipconfig /flushdns
    # Re-registers the system's DNS records with the DNS server
        ipconfig /registerdns
    # Resets the Windows Sockets API configuration to fix network connectivity issues
        netsh winsock reset
    # Resets the TCP/IP stack to its default configuration to fix network issues
        netsh ip reset

# Cache Cleanup
    # Reset Windows Store cache
        wsreset.exe
    # Deletes Windows Temp data to remove potentially problematic temporary files
        Remove-Item -Path $env:windir\Temp -Recurse -Force
    # Delete Windows Prefetch data to clear cached application data
        Remove-Item -Path $env:windir\Prefetch -Recurse -Force
    # Windows.old cleanup
        # takeown /r /a /d y /f $env:SystemDrive\Windows.old # Takes permissions before deleting old Windows, risky
        Remove-Item -Path $env:SystemDrive\Windows.old -Recurse -Force # Removes old Windows data

        slmgr /ato
# Malware Scan
    # Windows Defender Offline scan
        Start-MpWDOScan
