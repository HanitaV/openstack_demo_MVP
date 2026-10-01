[CmdletBinding()]
param()

Write-Host 'IPv4 addresses:' -ForegroundColor Cyan
Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike '127.*' } |
    Select-Object InterfaceAlias, IPAddress, PrefixLength | Format-Table -AutoSize

Write-Host 'Hyper-V switches:' -ForegroundColor Cyan
Get-VMSwitch -ErrorAction SilentlyContinue | Select-Object Name, SwitchType, NetAdapterInterfaceDescription | Format-Table -AutoSize

Write-Host 'Use the Ubuntu VM IPv4 address for Horizon: http://UBUNTU_VM_IP/dashboard' -ForegroundColor Yellow
