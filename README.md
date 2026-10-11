# Angels Installer

Public macOS install and uninstall scripts for **Angels**. This repository contains no application source files.

## Install Angels
Review [inst](inst) first, then run:

```bash
bash <(curl -fsSL "https://raw.githubusercontent.com/jaxonsfx-web/angelsinstaller/main/inst")
```

The installer shows an Angels banner and animated progress while it checks for the latest release, downloads the package, verifies the published SHA-256 checksum, and launches the standard macOS package installer targeting `/Applications`.

**Requires:** macOS on Apple Silicon (arm64), a published GitHub Release containing `Angels-arm64-<version>.pkg` and matching `.pkg.sha256`. **No installer is downloadable until that release exists.** The script may prompt for your administrator password.

## Uninstall Angels
Review [uninstaller](uninstaller) first, then run:

```bash
bash <(curl -fsSL "https://raw.githubusercontent.com/jaxonsfx-web/angelsinstaller/main/uninstaller")
```

The uninstaller finds only `/Applications/Angels.app` and `~/Applications/Angels.app`, lists the bundles it will remove, and requires the exact confirmation `UNINSTALL`. It does **not** remove Roblox, other applications, caches, or user settings.

## Publishing releases
Publish compiled packages as GitHub Release assets with corresponding SHA-256 checksums; the installer will never need source repository credentials. Do not add application source files, development archives, or debugging artifacts to this public repository.

**Licensing:** An installer-only repository does not remove source-availability obligations for any application derived from GPL-3.0-covered code. Provide corresponding application source to binary recipients as required.

## Limitations
The installer and uninstaller are shell scripts and have not yet been end-to-end tested on a released Angels build. Ensure macOS code signing/notarization is addressed before public distribution. A checksum alongside a release verifies download integrity but is not a substitute for a trusted signing identity.
