# TO DO List

- [x] Update install script to clone and freeze the homebrew-cask tap as well for 5fa601d38701d601e33f9c305a047a3ca8078810 which is the first commit on Sept 1st 2024 corresponding as close as possible to the homebrew-core first commit on Sept 1st.
- [x] Halt installation if brew was previously installed.
- [x] Document the installation process in a README file for users.
- [x] Ensure the install script checks for existing Homebrew installations and handles them appropriately.
- [x] Create a backup of existing .zshrc before modifying it.
- [x] Add a feature to the install script to uninstall Homebrew if needed. Properly backs up and cleans out all related files.

- [x] One install script

- [ ] One setup script
- [ ] Create a share creation script to create all the structures on it.
- [ ] Create a script to automate the installation of commonly used Homebrew packages post-installation.
- [ ] The install script should run brew bundle --file=path/to/Brewfile to install a predefined set of packages but with the frozen version.