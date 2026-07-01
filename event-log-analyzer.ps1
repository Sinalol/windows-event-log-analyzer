param(
    [int]$HoursBack = 24,
    [string]$OutputPath = ".\event-log-report.csv"
)

$startTime = (Get-Date).AddHours(-$HoursBack)

$eventTypes = @{
    4624 = "Successful Logon"
    4625 = "Failed Logon"
    4740 = "Account Lockout"
}

Write-Host "Analyzing Windows Security events from the last $HoursBack hours..."
Write-Host ""

try {
    $events = Get-WinEvent -FilterHashtable @{
        LogName   = "Security"
        Id        = 4624, 4625, 4740
        StartTime = $startTime
    } -ErrorAction Stop
}
catch {
    Write-Error "Unable to read the Security log. Run PowerShell as Administrator."
    exit 1
}

$results = foreach ($event in $events) {
    $xml = [xml]$event.ToXml()

    $eventData = @{}

    foreach ($item in $xml.Event.EventData.Data) {
        $eventData[$item.Name] = $item.'#text'
    }

    $username = $eventData["TargetUserName"]

    if (-not $username) {
        $username = $eventData["SubjectUserName"]
    }

    [PSCustomObject]@{
        TimeCreated     = $event.TimeCreated
        EventID         = $event.Id
        EventType       = $eventTypes[$event.Id]
        Username        = $username
        Domain          = $eventData["TargetDomainName"]
        IPAddress       = $eventData["IpAddress"]
        WorkstationName = $eventData["WorkstationName"]
        LogonType       = $eventData["LogonType"]
        Computer        = $event.MachineName
    }
}

if (-not $results) {
    Write-Host "No matching events were found."
    exit 0
}

$results |
    Sort-Object TimeCreated -Descending |
    Format-Table TimeCreated, EventID, EventType, Username, IPAddress -AutoSize

$results |
    Sort-Object TimeCreated -Descending |
    Export-Csv -Path $OutputPath -NoTypeInformation

$failedLogons = ($results | Where-Object EventID -eq 4625).Count
$successfulLogons = ($results | Where-Object EventID -eq 4624).Count
$accountLockouts = ($results | Where-Object EventID -eq 4740).Count

Write-Host ""
Write-Host "Summary"
Write-Host "-------"
Write-Host "Successful logons: $successfulLogons"
Write-Host "Failed logons:     $failedLogons"
Write-Host "Account lockouts:  $accountLockouts"
Write-Host ""
Write-Host "Report exported to: $OutputPath"

if ($failedLogons -ge 10) {
    Write-Warning "A high number of failed logons was detected."
}
