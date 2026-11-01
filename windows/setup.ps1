# Sets up the Windows side: apps from winget.json and the PowerShell 7 profile.
$ErrorActionPreference = 'Stop'

winget import --input (Join-Path $PSScriptRoot 'winget.json') --accept-package-agreements --accept-source-agreements
if ($LASTEXITCODE -ne 0) {
    Write-Warning "winget import exited with code $LASTEXITCODE. Continuing with the profile."
}

$documents = [Environment]::GetFolderPath('MyDocuments')
$profileDir = Join-Path $documents 'PowerShell'
$target = Join-Path $profileDir 'Microsoft.PowerShell_profile.ps1'

New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
if (Test-Path $target) {
    $backup = "$target.$(Get-Date -Format 'yyyyMMddHHmmss').bak"
    Copy-Item -Path $target -Destination $backup
    Write-Host "Backed up existing profile to $backup"
}
Copy-Item -Path (Join-Path $PSScriptRoot 'profile.ps1') -Destination $target -Force
Write-Host "Installed profile to $target"
