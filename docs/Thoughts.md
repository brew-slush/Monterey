# Thoughts

## Modes

- **Brew Slush Setup**: `slush-setup`, clones the homebrew-core and homebrew-cask repositories at specified commit hashes into the share
- **Per Machine Installation**: `brew-install`, installs Homebrew for users on individual Monterey machines using the frozen repositories as the origin, and sets up the user's environment to use them

>At least one machine during the per machine installation should be setup to fetch casks and formulae for archiving purposes in the background at off peak hours.

## User Steps
