# Services

# Services to start automatically
$on = @(
    # Updates and WinGet
        "UsoSvc",
        "wuauserv",
        "WaaSMedicSvc",
        "InstallService",
        "DoSvc",
    # Filesystem and indexing
        "WSearch",
        "SysMain",
        "UnistoreSvc",
        "UserDataSvc",
    # System time
        "tzautoupdate",
        "W32Time",
    # Networking
        "NetTcpPortSharing",
        "Dnscache",
        "WlanSvc",
        "dot3svc",
        "WebClient",
        "BITS",
    # Bluetooth
        "BluetoothUserService",
        "BTAGService",
        "bthserv"
)

# Uncategorized
$uncategorized = @(
    "A",
    "SensrSvc",
    "SensorService",
    "WpnUserService",
    "WpnService",
    "UevAgentService",
    "svsvc",
    "Winmgmt",
    "whesvc",
    "PrintNotify",
    "Spooler",
    "Fax",
    "PrintWorkflowUserSvc",
    "StiSvc",
    "FrameServer",
    "WiaRpc"
)

function Set-WindowsServices {
    [CmdletBinding()]
    param (
        [string[]]$On = @(),
        [string[]]$OnDelay = @(),
        [string[]]$Manual = @(),
        [string[]]$Off = @()
    )

    $configurations = @(
        @{ List = $On;      Startup = "auto";     Start = $true  },
        @{ List = $OnDelay; Startup = "delayed-auto"; Start = $true  },
        @{ List = $Manual;  Startup = "demand";   Start = $false },
        @{ List = $Off;     Startup = "disabled"; Start = $false }
    )

    foreach ($config in $configurations) {
        foreach ($svcName in $config.List) {
            $svc = Get-Service -Name $svcName -ErrorAction SilentlyContinue

            if (-not $svc) {
                Write-Host "⚠️ Service non-existent: $svcName" -ForegroundColor Yellow
                continue
            }

            # Set Startup Type
            $null = & sc.exe config $svcName start= $config.Startup 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Host "❌ Failed to set startup '$($config.Startup)' on: $svcName" -ForegroundColor Red
                continue
            }

            # Handle Service Execution State
            if ($config.Start) {
                if ($svc.Status -ne 'Running') {
                    Start-Service -Name $svcName -ErrorAction SilentlyContinue
                    if ((Get-Service -Name $svcName).Status -ne 'Running') {
                        Write-Host "❌ Failed to start service: $svcName" -ForegroundColor Red
                    }
                }
            } else {
                if ($svc.Status -eq 'Running') {
                    Stop-Service -Name $svcName -Force -ErrorAction SilentlyContinue
                    if ((Get-Service -Name $svcName).Status -eq 'Running') {
                        Write-Host "❌ Failed to stop service: $svcName" -ForegroundColor Red
                    }
                }
            }
        }
    }
}

# Execute Core Logic
Set-WindowsServices -On $on -OnDelay $on_delay -Manual $manual -Off $off
