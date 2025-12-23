# Notes

## Installation Backups

Previous non-frozen installations will always be there. Backups of existing Homebrew
installations are created in the ${BREW_SLUSH_HOME}/backups directory under the host's
unqualified hostname. Example: if the machine's full hostname is "my-mac.local", and
BREW_SLUSH_HOME is /Volumes/BrewSlush/Monterey, the backup's timestamped directory
will be stored under "/Volumes/BrewSlush/Monterey/backups/my-mac/..." subdirectory.

The brew-install script checks if there's a previous installation by looking for
the /usr/local/Homebrew directory (Intel Macs) or /opt/homebrew directory (Apple
Silicon Macs). If found, it creates a backup of the entire Homebrew installation
directory, along with the user's Homebrew configuration files such as .zshrc,
.bash_profile, and .bashrc in the user's home directory.


## Committed Patches

When we find a need to patch Homebrew core or cask, we create a patch file
and store it in the `repos` directory under a folder named with the short hash
of the Homebrew commit it applies to, suffixed with `_core_patches` or
`_cask_patches`.

During installation, these patches are applied automatically if the relevant
patch directory exists. The installation script looks for patch files in these
directories and applies them in sorted order. This ensures that any necessary
modifications to Homebrew are consistently applied during setup.

This mechanism allows us to maintain custom patches that address specific
issues that were never fixed at the frozen version of Homebrew we are using.
