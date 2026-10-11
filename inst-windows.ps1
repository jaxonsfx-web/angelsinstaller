# Angels Windows installer (run in PowerShell)
$ErrorActionPreference = 'Stop'
$repo = 'jaxonsfx-web/angelsinstaller'
Write-Host 'ANGELS | Windows Installer' -ForegroundColor White
if (-not [Environment]::Is64BitOperatingSystem) { throw 'Angels Windows currently requires 64-bit Windows.' }
$headers = @{ 'User-Agent' = 'Angels-Windows-Installer'; 'Accept' = 'application/vnd.github+json' }
$releases = @(Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/releases?per_page=30" -Headers $headers)
$selected = $null
foreach ($release in $releases) {
    if ($release.draft -or $release.prerelease) { continue }
    $asset = @($release.assets | Where-Object { $_.name -match '^Angels-Windows-x64-[0-9][0-9A-Za-z.\-]*\.(exe|msi)$' } | Select-Object -First 1)
    if ($asset.Count -eq 0) { continue }
    $check = @($release.assets | Where-Object { $_.name -eq ($asset[0].name + '.sha256') } | Select-Object -First 1)
    if ($check.Count -eq 0) { continue }
    $selected = @{ release = $release; asset = $asset[0]; checksum = $check[0] }
    break
}
if (-not $selected) {
    Write-Host 'No verified Angels Windows installer has been published yet.' -ForegroundColor Yellow
    Write-Host "Check https://github.com/$repo/releases for future releases."
    return
}
$base = "https://github.com/$repo/releases/download/"
foreach ($item in @($selected.asset, $selected.checksum)) {
    if (-not $item.browser_download_url.StartsWith($base, [StringComparison]::OrdinalIgnoreCase)) {
        throw 'Untrusted download location returned by release metadata.'
    }
}
$tempDir = Join-Path ([IO.Path]::GetTempPath()) ('AngelsInstall-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $tempDir | Out-Null
try {
    $path = Join-Path $tempDir $selected.asset.name
    $sumPath = "$path.sha256"
    Invoke-WebRequest -Uri $selected.asset.browser_download_url -OutFile $path -Headers $headers
    Invoke-WebRequest -Uri $selected.checksum.browser_download_url -OutFile $sumPath -Headers $headers
    $sumText = (Get-Content -Raw -LiteralPath $sumPath).Trim()
    if ($sumText -notmatch '^([0-9a-fA-F]{64})(?:\s+\*?.+)?$') { throw 'Malformed SHA-256 checksum.' }
    $expected = $Matches[1]
    $actual = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash
    if ($actual -ne $expected) { throw 'Checksum mismatch. Installation cancelled.' }
    Write-Host ('Verified ' + $selected.asset.name) -ForegroundColor Green
    $reply = Read-Host 'Launch the Windows installer? [y/N]'
    if ($reply -notin @('y','Y','yes','YES')) { Write-Host 'Cancelled.'; return }
    if ($selected.asset.name.EndsWith('.msi', [StringComparison]::OrdinalIgnoreCase)) {
        $process = Start-Process -FilePath msiexec.exe -ArgumentList @('/i', ('"' + $path + '"')) -Wait -PassThru
    } else {
        $process = Start-Process -FilePath $path -Wait -PassThru
    }
    if ($process.ExitCode -ne 0) { throw "Installer exited with code $($process.ExitCode)" }
    Write-Host 'Angels Windows installer finished.' -ForegroundColor Green
} finally {
    Remove-Item -LiteralPath $tempDir -Recurse -Force -ErrorAction SilentlyContinue
}
