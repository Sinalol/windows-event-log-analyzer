# Windows Event Log Analyzer

A PowerShell cybersecurity tool that analyzes Windows Security event logs and creates a CSV report.

## Features

- Detects successful logins using Event ID 4624
- Detects failed login attempts using Event ID 4625
- Detects account lockouts using Event ID 4740
- Displays usernames, IP addresses, workstations, and login types
- Warns when a high number of failed logins is detected
- Exports results to a CSV file

## Requirements

- Windows 10 or Windows 11
- PowerShell 5.1 or newer
- Administrator privileges

## How to Run

Open PowerShell as Administrator.

Navigate to the folder containing the script:

```powershell
cd "C:\path\to\windows-event-log-analyzer"
