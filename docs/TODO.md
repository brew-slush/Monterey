# TO DO List

- [x] Update install script to clone and freeze the homebrew-cask tap as well for 5fa601d38701d601e33f9c305a047a3ca8078810 which is the first commit on Sept 1st 2024 corresponding as close as possible to the homebrew-core first commit on Sept 1st.
- [ ] One install script and one setup script.


- [ ] Halt installation if brew was previously installed.
- [x] Document the installation process in a README file for users.
- [ ] Ensure the install script checks for existing Homebrew installations and handles them appropriately.
- [ ] Create a backup of existing .zshrc before modifying it.


- [ ] Create a share creation script to create all the structures on it.


- [ ] Add a feature to the install script to uninstall Homebrew if needed. Properly backs up and cleans out all related files.


- [ ] Create a script to automate the installation of commonly used Homebrew packages post-installation.


Two modes/steps:

- **Brew Slush Setup**: `slush-setup`, clones the homebrew-core and homebrew-cask repositories at specified commit hashes into the share
- **Per Machine Installation**: `brew-install`, installs Homebrew for users on individual Monterey machines using the frozen repositories as the origin, and sets up the user's environment to use them

>At least one machine during the per machine installation should be setup to fetch casks and formulae for archiving purposes in the background at off peak hours.
