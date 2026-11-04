# Sets up the Windows side: apps from winget.json, the PowerShell 7 profile and
# the Claude Code settings.
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

# Copied rather than linked: symlinks need admin rights or Developer Mode.
$claudeSource = Join-Path (Split-Path $PSScriptRoot -Parent) 'claude'
$claudeDir = Join-Path $HOME '.claude'

New-Item -ItemType Directory -Force -Path (Join-Path $claudeDir 'skills') | Out-Null
foreach ($name in 'settings.json', 'CLAUDE.md') {
    $target = Join-Path $claudeDir $name
    if (Test-Path $target) {
        $backup = "$target.$(Get-Date -Format 'yyyyMMddHHmmss').bak"
        Copy-Item -Path $target -Destination $backup
        Write-Host "Backed up existing $name to $backup"
    }
    Copy-Item -Path (Join-Path $claudeSource $name) -Destination $target -Force
}
Get-ChildItem -Path (Join-Path $claudeSource 'skills') -Directory | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination (Join-Path $claudeDir 'skills') -Recurse -Force
}
Write-Host "Installed Claude Code settings to $claudeDir"
