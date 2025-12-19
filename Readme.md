# Monterey Brew Slushy

Scripts to build a frozen version of Homebrew local repositories to install and continue using brew on macOS Monterey without having to deal with incompatible packages requiring pinning. It also allows for offline installation and ensures compatibility with the Monterey version of macOS.

Intended to be mounted as a share on target Monterey machines to take advantage of bottle and cask caching for much faster repeat installations.

## Setup

I advise cloning this repository somewhere preferably to a designated network share (on a NAS etc.) that any Monterey machine on your network can mount. Still you can install it locally if you still wish.

```bash
git clone https://github.com/akarasulu/MontereyBrewSlushy.git /exported/Monterey
```

Run setup to build your local repositories on the Monterey share. For Monterey brew ended support in version 4.4.0 on October 1st 2024. For stability I froze just a month before on September 1st 2024. Always the first commit of the day for all repositories.

```bash
cd /exported/Monterey
bash bin/setup
```

## Frozen Homebrew Installation

After that, for each Monterey machine (which you mount the share on) you can run install in the `bin` directory:

```bash
bash ${MOUNT_POINT}/bin/install
```

This will install Homebrew from the at least fast LAN local (on a remote share) frozen repositories and set up your shell environment on each Monterey machine. The share also acts as a bottle cache for faster installations of bottles and casks across machines, especially formula that were compiled from source then bottled.
