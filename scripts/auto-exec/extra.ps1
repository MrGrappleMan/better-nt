# Other small scripts

# Time
    w32tm /register
    w32tm /config /syncfromflags:all /manualpeerlist:"time.google.com time.windows.com time.cloudflare.com pool.ntp.org time.facebook.com time.apple.com time.aws.com" /reliable:YES /update

# WinGet
    winget upgrade --all # Upgrade all packages
    Set-Location "$Env:windir\\Temp\\windosill\\export\\winget\\" # Winget jsons location
    Get-ChildItem -File | ForEach-Object { winget import -i $_.FullName --ignore-unavailable --ignore-versions --accept-package-agreements --accept-source-agreements }

# Registry
    Set-Location "$Env:windir\\Temp\\windosill\\export\\registry\\" # Registry exports location
    Get-ChildItem -File | ForEach-Object { regedit /s $_.FullName }
