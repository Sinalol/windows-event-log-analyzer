Run the script:

```powershell
.\event-log-analyzer.ps1
```

Analyze a different time period:

```powershell
.\event-log-analyzer.ps1 -HoursBack 48
```

Choose a custom output file:

```powershell
.\event-log-analyzer.ps1 -OutputPath ".\security-report.csv"
```

## Output

The script displays a summary in PowerShell and exports detailed results to:

```text
event-log-report.csv
```

## Windows Event IDs

| Event ID | Meaning |
|---|---|
| 4624 | Successful logon |
| 4625 | Failed logon |
| 4740 | Account locked out |

## Disclaimer

This project is intended for educational and defensive cybersecurity purposes.
