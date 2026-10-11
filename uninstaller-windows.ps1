# Angels Windows uninstaller. Only targets a registered app named exactly Angels.
$ErrorActionPreference = 'Stop'
Write-Host 'ANGELS | Windows Uninstaller' -ForegroundColor White
$roots = @(
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall',
    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall',
    'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
)
$found = @()
foreach ($root in $roots) {
    if (!(Test-Path $root)) { continue }
    foreach ($key in @(Get-ChildItem -LiteralPath $root -ErrorAction SilentlyContinue)) {
        $entry = Get-ItemProperty -LiteralPath $key.PSPath -ErrorAction SilentlyContinue
        if ($entry -and $entry.DisplayName -eq 'Angels' -and $entry.UninstallString) {
            $found += [pscustomobject]@{ Key = $key.PSPath; Command = [string]$entry.UninstallString; Name = $entry.DisplayName }
        }
    }
}
if ($found.Count -eq 0) {
    Write-Host 'No installed Angels Windows entry found. Nothing removed.' -ForegroundColor Yellow
    Write-Host 'This script will not uninstall Bloxstrap or Roblox.'
    return
}
if ($found.Count -gt 1) { throw 'Multiple Angels uninstall entries found. Uninstall through Windows Settings > Apps to select the correct installation.' }
$entry = $found[0]
Write-Host 'Detected an installed app registered as Angels.'
Write-Host 'Roblox and Bloxstrap will not be removed.'
Write-Host 'Personal settings will be left intact unless the official uninstaller offers a separate choice.'
$answer = Read-Host 'Type UNINSTALL to run its registered uninstaller'
if ($answer -cne 'UNINSTALL') { Write-Host 'Cancelled.'; return }
$cmd = $entry.Command.Trim()
# Only launch direct local executable paths or the standard Windows Installer entry.
if ($cmd -match '(?i)^"?((?:[A-Z]:\\)[^"]*?msiexec(?:\.exe)?)"?\s+(.*)$' -or $cmd -match '(?i)^msiexec(?:\.exe)?\s+(.*)$') {
    if ($cmd -notmatch '(?i)\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}') { throw 'Windows Installer entry has no valid product GUID.' }
    $id = $Matches[0]
    $process = Start-Process -FilePath 'msiexec.exe' -ArgumentList @('/x', $id) -Wait -PassThru
} else {
    if ($cmd -notmatch '^"([^"]+\.exe)"(?:\s+(.*))?$') {
        throw 'Uninstaller command format needs manual review. Use Windows Settings > Installed apps > Angels.'
    }
    $exe = $Matches[1]
    $args = $Matches[2]
    if (-not [IO.Path]::IsPathRooted($exe) -or !(Test-Path -LiteralPath $exe -PathType Leaf)) {
        throw 'Registered uninstaller executable was not found.'
    }
    # Do not evaluate the command through cmd.exe or PowerShell.
    $process = Start-Process -FilePath $exe -ArgumentList @($args) -Wait -PassThru
}
if ($process.ExitCode -ne 0) { throw "Uninstaller exited with code $($process.ExitCode)" }
Write-Host 'Angels uninstaller completed.' -ForegroundColor Green
