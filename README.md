# Angels Installer
Public installer for **Angels**, the macOS Roblox launcher.

This repository contains **installation scripts and release metadata only**, not the application source tree. Compiled installers must be published as GitHub Release assets to become downloadable.

## Install (Apple Silicon)
Review [inst](inst) before running:
```bash
bash <(curl -fsSL "https://raw.githubusercontent.com/jaxonsfx-web/angelsinstaller/main/inst")
```

The script downloads the latest published `Angels-arm64-<version>.pkg` and matching `.sha256` asset, checks the checksum, and invokes the macOS installer. **Until a release exists, the install command will report that no package is available.**

## Releases and updates
Upload a built Angels package and a matching checksum file to a GitHub Release in this repository. The application can check `https://api.github.com/repos/jaxonsfx-web/angelsinstaller/releases/latest` for the current release.

**License notice:** Publishing an installer without source files does not eliminate source-availability obligations for software incorporating GPL-licensed code. Ensure recipients can access the corresponding source code in accordance with the upstream licenses.

This installer does not request GitHub credentials or download private repository contents.
