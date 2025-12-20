# Monterey Brew Slush

Build a frozen Homebrew time capsule to future-proof usage on macOS Monterey forever.

Monterey Brew Slush is a set of scripts to create a frozen snapshot of Homebrew repositories, bottles, and casks as they exist on macOS Monterey before Homebrew discontinued support for the OS. This allows users to continue using Homebrew on Monterey indefinitely without worrying about missing packages, sources, or broken installations.

## Motivation

Homebrew users may not have the option of upgrading their macOS version. Hardware limitations or software compatibility requirements may prevent upgrading. Before giving up though, take a look at [OpenCore Legacy Patcher](https://dortania.github.io/OpenCore-Legacy-Patcher/) which may allow installing newer macOS versions on unsupported hardware.

Without Brew Slush, users stuck on older macOS versions eventually notice unsupported Homebrew installations breaking as packages and bottles become unavailable or change so much even source builds break. As packages change over time, and bottles are not built and no longer available, users are forced to build more packages themselves from sources. This is time consuming, error prone, and requires constant maintenance as packages evolve.

>Some propose pinning packages to specific versions to avoid breakage. The counter argument is the lack of viability as package sources eventually become unavailable, or the package may depend on other packages that have changed or been removed. Pinning only works for a short time before the entire installation becomes unsustainable. Its a lot of painstaking work users will need to perform regularly as Homebrew Formulae evolve. Pinning effectively freezes one package at a time as problems arise requiring constant maintenance overhead.

The primary motivation for Brew Slush is to avoid the constantly recurring overhead of build packages from source which often break requiring broken package sources to be patched. This basically means users must become Homebrew package maintainers for their own systems. That's overwhelming, and an absurd proposition for normal users to take on. Even pinning is too much effort.

Brew Slush freezes everything as it was before Homebrew dropped support. This is a one time setup operation without ongoing maintenance. Once set up, users continue to use Homebrew on Monterey as normal without worrying about packages breaking or becoming unavailable in the future.

## **WARNING**: Security Tradeoff

All dandy but what's the price to pay? The tradeoff is that frozen packages and bottles will not receive updates. This means no new features or feature updates, no bug fixes, and most importantly no security patches. Over time, this may expose users to security vulnerabilities in the frozen packages.

This is a tradeoff users must accept to continue using Homebrew on Monterey without the maintenance overhead of fixing and building broken packages. Users should be aware of the security implications and take appropriate measures to mitigate risks.

With Brew Slush you at least have an option. It's up to you to decide if this tradeoff is acceptable for your use case.

## Setup

Clone this repository somewhere, preferably on a network share (on a NAS etc.) so any Monterey machine on your network can mount it. You can install it locally (isolated) on a single machine too, just make sure you have enough free disk space (enough means >= 1 TB):

```bash
git clone https://github.com/brew-slush/Monterey.git /exported/Monterey
```

### One Time Setup

On any Monterey machine, mount the share and run the setup script `/mount/path/Monterey/bin/setup` from the cloned repository once. The setup script clones, and freezes locally cloned repositories and creates static convenience indices for them to speed up certain operations.

### Per Monterey Machine Install

There's a brew `backup-restore` script included to backup and restore your existing Homebrew installations on Monterey machines. You cannot run the `install` script on machines with existing Homebrew installations. The `backup-restore` script backs up to the mounted partition under the `backups/$(hostname)`:

```bash
# Do it carefully step by step!
bash ${MOUNT_POINT}/bin/backup-restore --backup
# To verify restore will work later but not restore yet
bash ${MOUNT_POINT}/bin/backup-restore --restore --source "${MOUNT_POINT}/backups/$(hostname)/${backup_directory}"
# Check the backup then wipe the existing installation
bash ${MOUNT_POINT}/bin/backup-restore --clean-only --source "${MOUNT_POINT}/backups/$(hostname)/${backup_directory}"


# Or just do the both operations in one go
bash ${MOUNT_POINT}/bin/backup-restore --backup --clean --source "${MOUNT_POINT}/backups/$(hostname)/${backup_directory}"
# Straight up restore
bash ${MOUNT_POINT}/bin/backup-restore --restore --apply --source "${MOUNT_POINT}/backups/$(hostname)/${backup_directory}"
```

>**WARNING**: We take no responsibility for borked systems. Use at your own risk. Always take a backup before even using these tools. With that said, attention was given to the `backup-restore` script with some testing and it works well, but it may not work for you depending on your existing Homebrew installation.

```bash
bash ${MOUNT_POINT}/bin/install
```

This will install Homebrew from the frozen repositories on the mounted share and set up the environment to use them. You can now use Homebrew as normal on your Monterey machine. You can use the Brewfile from your backup to restore your past brew installation's installed packages but at the versions available at the time of freezing.

## Fetch Everything

To fetch all bottles and casks into the archive, run the batch fetch script. This may take a long time and require a lot of disk space (up to 1 TB or more):

### Basic Usage (Non-Resumable)

```bash
bash ${MOUNT_POINT}/bin/batch-fetch
```

### Resumable Mode for Cron Jobs

The script supports resumable mode which saves progress and allows you to stop and restart without losing work. Perfect for cron jobs that run during off-peak hours:

```bash
# Enable resumable mode with 2-hour runtime limit
bash ${MOUNT_POINT}/bin/batch-fetch --resumable --max-runtime 2h

# Process specific number of batches then exit
bash ${MOUNT_POINT}/bin/batch-fetch --resumable --max-batches 50

# Reset state and start over
bash ${MOUNT_POINT}/bin/batch-fetch --resumable --reset

# Custom window size
bash ${MOUNT_POINT}/bin/batch-fetch --resumable --window 20 --max-runtime 1h
```

### Example Cron Schedule

Add to your crontab to fetch during specific times without disrupting your network:

```bash
# Run for 1 hour at lunch time (12 PM) on weekdays
0 12 * * 1-5 bash /Volumes/Monterey/bin/batch-fetch --resumable --max-runtime 1h

# Run for 4 hours every evening (6 PM)
0 18 * * * bash /Volumes/Monterey/bin/batch-fetch --resumable --max-runtime 4h

# Run overnight (11 PM to 7 AM on weekends)
0 23 * * 6,0 bash /Volumes/Monterey/bin/batch-fetch --resumable --max-runtime 8h
```

### Network Considerations

For network-friendly operation, consider:
- Using `--max-runtime` to limit batch fetch duration during business hours
- Running overnight or during off-peak times via cron
- Configuring QoS on your router (e.g., OpenWRT with SQM) to prioritize interactive traffic like video calls over bulk downloads
