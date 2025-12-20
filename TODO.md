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


This is great. This is exactly what we wanted for the install_clt but could not do it right. Now let's change dual-log-ui by adding the functionality from install_clt to it. Here's what we will do: (1) status bullets are printed into the buffer and the top window while scrolling to fit as done in dual-log-ui already, and (2) the tail from the installer logs is printed into the second window.