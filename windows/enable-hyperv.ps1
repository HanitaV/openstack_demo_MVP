[CmdletBinding(SupportsShouldProcess)]
param()

Write-Warning 'This enables Hyper-V and requires an administrator PowerShell session plus a restart. Save all work first.'
if (-not $PSCmdlet.ShouldProcess('Windows optional features', 'Enable Hyper-V')) { return }

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
Write-Host 'Hyper-V enabled. Restart Windows before creating the Ubuntu VM.' -ForegroundColor Green
