[CmdletBinding()]
param()

$computer = Get-CimInstance Win32_ComputerSystem
$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$systemDrive = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$($env:SystemDrive)'"
$hyperVFeature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -ErrorAction SilentlyContinue
$firmware = Get-CimInstance Win32_ComputerSystem | Select-Object -ExpandProperty HypervisorPresent
$vmMonitor = Get-CimInstance Win32_Processor | Select-Object -ExpandProperty VMMonitorModeExtensions

Write-Host "OpenStack MVP Windows host check" -ForegroundColor Cyan
[pscustomobject]@{
    'Windows version' = "$($os.Caption) ($($os.Version))"
    'RAM (GB)' = [math]::Round($computer.TotalPhysicalMemory / 1GB, 1)
    'CPU model' = $cpu.Name.Trim()
    'CPU core count' = ($computer.NumberOfLogicalProcessors)
    'Hyper-V status' = if ($hyperVFeature.State -eq 'Enabled') { 'Enabled' } else { "$($hyperVFeature.State) (not enabled)" }
    'Hypervisor detected' = $firmware
    'Virtualization support' = if ($vmMonitor) { 'Supported' } else { 'Not detected' }
    'Free system disk (GB)' = [math]::Round($systemDrive.FreeSpace / 1GB, 1)
} | Format-List

Write-Host "Recommended for the Ubuntu VM: 4 vCPU, 10 GB RAM, 60 GB dynamic disk, Default Switch." -ForegroundColor Yellow
if ($hyperVFeature.State -ne 'Enabled') {
    Write-Warning 'Hyper-V is not enabled. Run enable-hyperv.ps1 only after saving work; it requires a reboot.'
}
