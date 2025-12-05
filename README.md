# Homebrew Tap for Performance Co-Pilot

This is a custom Homebrew tap for installing [Performance Co-Pilot (PCP)](https://pcp.io/) on macOS.

## Installation

To install PCP using this tap:

```bash
brew tap performancecopilot/performancecopilot
brew install --cask pcp-perf
```

Or install directly without tapping first:

```bash
brew install --cask performancecopilot/performancecopilot/pcp-perf
```

## About Performance Co-Pilot

Performance Co-Pilot (PCP) is a system performance analysis toolkit that provides:

- Live performance monitoring and logging
- Distributed system monitoring capabilities
- Extensible monitoring framework with agents (PMDAs)
- Flexible data collection and analysis tools
- Integration with visualization tools like Grafana

**Links:**
- **Homepage**: https://pcp.io/
- **Source**: https://github.com/performancecopilot/pcp
- **Documentation**: https://pcp.io/docs/

## What Gets Installed

PCP installs several system services that start automatically:

- **io.pcp.pmcd** - Performance Metrics Collector Daemon
- **io.pcp.pmie** - Performance Metrics Inference Engine
- **io.pcp.pmlogger** - Performance Metrics Logger
- **io.pcp.pmproxy** - Performance Metrics Proxy

**Installation locations:**
- Configuration: `/etc/pcp/`
- Data directory: `/var/lib/pcp/`
- Log files: `/var/log/pcp/`

## Uninstalling

### Standard Uninstall
To uninstall PCP while preserving configuration and log files:

```bash
brew uninstall pcp-perf
```

This will:
- Stop and remove all PCP services (pmcd, pmie, pmlogger, pmproxy)
- Remove the installed package
- Leave configuration files in /etc/pcp/ intact
- Leave data files in /var/lib/pcp/ intact
- Leave log files in /var/log/pcp/ intact

### Complete Uninstall

To completely remove PCP including all configuration and data files:

```bash
brew uninstall --zap pcp-perf
```

This performs a standard uninstall plus removal of all configuration, data, and log directories.

### Manual .pkg Uninstall

If you installed PCP using the .pkg installer (not Homebrew), you can use the bundled uninstall script:

**Standard Uninstall (preserves config/log files):**
```bash
sudo /usr/local/libexec/pcp/bin/uninstall-pcp
```

This will prompt for confirmation and remove PCP, leaving configuration and log files in place.

**Complete Uninstall (removes everything):**
```bash
sudo /usr/local/libexec/pcp/bin/uninstall-pcp --force
```

This skips the confirmation prompt and removes all PCP files including configuration, data, and logs.

## For Maintainers

### Version Format

PCP uses a two-part versioning scheme: `MAJOR.MINOR.PATCH-BUILD`

**Example:** `7.0.4-1`
- **Release tag:** `7.0.4` (used in GitHub release URLs)
- **Build number:** `-1` (appended to DMG and PKG filenames)

This is important to understand when updating versions:
- GitHub release tag is just the semantic version: `7.0.4`
- The downloadable DMG file includes the build number: `pcp-7.0.4-1.dmg`
- The cask uses `version.major_minor_patch` to extract `7.0.4` for the download URL

**When updating to new versions, ensure both parts are included in the version string.**

### Updating for New Releases

When a new version of PCP is released, follow these steps to update the cask:

1. **Download the new DMG** from the [PCP releases page](https://github.com/performancecopilot/pcp/releases):
   ```bash
   # Note: Release tag is X.Y.Z, but DMG filename includes build number
   curl -LO https://github.com/performancecopilot/pcp/releases/download/X.Y.Z/pcp-X.Y.Z-B.dmg
   ```

2. **Calculate SHA256 checksum**:
   ```bash
   shasum -a 256 pcp-X.Y.Z-B.dmg
   ```

3. **Update the cask file** (`Casks/pcp-perf.rb`):
   - Update the `version` field to include both version and build: `X.Y.Z-B`
   - Update the `sha256` field with the calculated checksum
   - Example: For release 7.0.5 with build 2, use `version "7.0.5-2"`

4. **Test locally** before pushing:
   ```bash
   brew reinstall --cask pcp-perf
   ```

5. **Commit and push changes**:
   ```bash
   git add Casks/pcp-perf.rb
   git commit -m "Update pcp-perf to version X.Y.Z-B"
   git push
   ```

### Testing Changes Locally

To test local changes before publishing:

```bash
# Tap the local repository
brew tap --force performancecopilot/performancecopilot /Users/psmith/dev/pcp/brew-pcp

# Install from local tap
brew install --cask pcp-perf

# Verify installation
brew list --cask pcp-perf
```

### Cask Audit

To check the cask for issues:

```bash
brew audit --cask --online Casks/pcp-perf.rb
```

## Why a Custom Tap?

The name `pcp` is already taken in Homebrew by an unrelated package. This custom tap uses the name `pcp-perf` to distinguish Performance Co-Pilot while maintaining a clear connection to the project.

## License

This tap repository is maintained independently of the Performance Co-Pilot project.

- **PCP License**: See the [PCP repository](https://github.com/performancecopilot/pcp) for license details
- **This tap**: Provided as-is for the convenience of macOS users

## Contributing

Issues and pull requests are welcome! Please ensure:

- Cask follows [Homebrew Cask style guidelines](https://docs.brew.sh/Cask-Cookbook)
- Changes are tested locally before submitting
- Version updates include updated SHA256 checksums
