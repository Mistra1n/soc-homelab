<#
.SYNOPSIS
  Installs Sysmon with the SwiftOnSecurity community config on the Windows lab victim.
.NOTES
  Run in an elevated PowerShell on the VICTIM VM only.
  Needs internet for the download; use a temporary NAT adapter, then switch back to host-only.
#>

$ErrorActionPreference = 'Stop'
$work = Join-Path $env:TEMP 'sysmon-install'
New-Item -ItemType Directory -Force -Path $work | Out-Null

Invoke-WebRequest -Uri 'https://download.sysinternals.com/files/Sysmon.zip' -OutFile "$work\Sysmon.zip"
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml' -OutFile "$work\sysmonconfig.xml"

Expand-Archive -Path "$work\Sysmon.zip" -DestinationPath $work -Force

& "$work\Sysmon64.exe" -accepteula -i "$work\sysmonconfig.xml"

Get-Service Sysmon64 | Format-Table Name, Status
