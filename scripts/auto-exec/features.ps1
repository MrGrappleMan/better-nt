# Windows Features
# -NoRestart stages changes to the system, but does not restart

# Enable virtualization features
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart
    Enable-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform -All -NoRestart
