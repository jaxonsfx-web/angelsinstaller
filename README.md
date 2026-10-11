# Angels installers

[![Angels releases](https://img.shields.io/badge/releases-Angels-111111)](https://github.com/jaxonsfx-web/angelsinstaller/releases)

Lightweight installer and uninstaller scripts for **Angels macOS** and **Angels Windows**.

## macOS (Apple Silicon)

Open **Terminal**.

**Install / update:**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/jaxonsfx-web/angelsinstaller/main/inst)
```

**Uninstall (option to back up settings):**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/jaxonsfx-web/angelsinstaller/main/uninstaller)
```

The Mac installer finds the newest published compatible `.pkg`, verifies its SHA-256 checksum and requests confirmation when reinstalling.

## Windows (x64, Windows 10/11)

Open **PowerShell** (not Command Prompt). These commands download the script to a temporary local file so you can inspect it first. The scripts don't require changing the PowerShell execution policy system-wide.

**Prepare Windows installer:**

```powershell
Invoke-WebRequest 'https://raw.githubusercontent.com/jaxonsfx-web/angelsinstaller/main/inst-windows.ps1' -OutFile "$env:TEMP\angels-install.ps1"
notepad "$env:TEMP\angels-install.ps1"
powershell.exe -NoProfile -File "$env:TEMP\angels-install.ps1"
```

**Uninstall Angels Windows:**

```powershell
Invoke-WebRequest 'https://raw.githubusercontent.com/jaxonsfx-web/angelsinstaller/main/uninstaller-windows.ps1' -OutFile "$env:TEMP\angels-uninstall.ps1"
notepad "$env:TEMP\angels-uninstall.ps1"
powershell.exe -NoProfile -File "$env:TEMP\angels-uninstall.ps1"
```

The Windows installer **will not install** until a production Angels Windows x64 `.exe` or `.msi` plus a matching `.sha256` asset is published. A development Bloxstrap-based build is not a production Angels installer.

The Windows uninstaller uses a registered uninstallation entry whose display name is exactly `Angels`. It does not remove Roblox or Bloxstrap and does not delete personal files itself.

## Release naming

| Platform | Title | Tag | Example asset |
| --- | --- | --- | --- |
| macOS | Angels macOS 0.9.1 | `macos-v0.9.1` | `Angels-arm64-0.9.1.pkg` |
| Windows | Angels Windows 0.9.1 | `windows-v0.9.1` | `Angels-Windows-x64-0.9.1.exe` |

[Browse releases](https://github.com/jaxonsfx-web/angelsinstaller/releases)

## Source and licensing

Angels macOS derives from AppleBlox (GPL-3.0-only); a compliant distributor must make corresponding GPL source available to binary recipients. The Windows edition is being developed using Bloxstrap (MIT license), with its license and attribution retained. The private development repository alone does not satisfy the GPL source-availability requirement for publicly distributed binaries.
