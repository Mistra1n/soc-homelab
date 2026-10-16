<#
.SYNOPSIS
  Installs the Wazuh agent on a Windows lab machine and registers it with the SIEM.
.PARAMETER Manager
  IP address of the Wazuh server (e.g. 192.168.56.10).
.PARAMETER Version
  Agent version. Match your Wazuh server version.
.EXAMPLE
  .\install-wazuh-agent.ps1 -Manager 192.168.56.10 -Version 4.9.2
.NOTES
  Run elevated, on the VICTIM VM only.
#>
param(
  [Parameter(Mandatory)] [string] $Manager,
  [Parameter(Mandatory)] [string] $Version,
  [string] $AgentName = $env:COMPUTERNAME
)

$ErrorActionPreference = 'Stop'
$msi = Join-Path $env:TEMP "wazuh-agent-$Version.msi"
Invoke-WebRequest -Uri "https://packages.wazuh.com/4.x/windows/wazuh-agent-$Version-1.msi" -OutFile $msi

Start-Process msiexec.exe -Wait -ArgumentList "/i `"$msi`" /q WAZUH_MANAGER=`"$Manager`" WAZUH_AGENT_NAME=`"$AgentName`""
NET START WazuhSvc

Get-Service WazuhSvc | Format-Table Name, Status
