# Fetching Indices

As stated in [Archive-Everything](./Archive-Everything.md), all bottles are preemptively fetched into the cache and the cache is instead used as an archive. There are scripts that help out but to speed things up we created some indices which will never change thanks to the fact that the repositories are frozen in time.

## Indices

Brew is notorious for being slow when it comes to resolving dependencies, dependents, and installing packages. We're not going to be able to improve installation besides eliminating download times, but certain query operations can be sped up significantly by using alternative indices.

Frozen repositories offer opportunities for optimization. Operations like `brew deps` and `brew uses` can be significantly accelerated by precomputing and storing auxiliary indices. These alternative indices can be built once and reused multiple times since all is frozen in time, reducing the need for repeated computations.

The following alternative indices are precomputed and stored in the repos folder with file names prefixed with the hash of the repository freeze commit \<hash>\_\<index_name>:

- **all** - flat file single word per line list of all formulae
- **nodeps** - flat file single word per line list of all formulas with no dependencies (true leaves)
- **roots** - flat file single word per line list of formulas with no dependents (true dependency tree roots)

- **fetch-results** - flat file CSV of formula to fetch results with field order: formula name (string), bottle (boolean), source(boolean), error(string)
- **deps** - flat file CSV of formula to dependencies
- **uses** - flat file CSV of formula to dependents

When is this useful? When determining which formulas (installed and uninstalled) are leaves (i.e., have no dependents) or when installing a formula and needing to find all its dependencies quickly. By using these precomputed indices, we can significantly reduce the time taken for these operations, making the overall experience with Homebrew faster and more efficient. It is also useful when determining which bottles need to be built from source when missing bottles or both bottles and sources.

## Block Fetching Script

The brew fetch command is more efficient when given a list of formulae to fetch rather than fetching each formula one by one. The warmup overhead when launching brew is the primary reason for this.

The only problem with processing a group is that one formula failing to fetch causes the entire batch to fail with no attempt to fetch the other remaining formulae. Furthermore, brew fetch returns success when no bottle is available, yet the source is available. It downloads the source tarball and returns success. This behavior is not ideal when prefetching bottles for archiving.

The fetch script processes a block of formulae at a time from a file. If one formula in the block fails to fetch, it retries the block minus the failing formula. It does so recursively until all formulae in the block are either fetched or failed to fetch at all for some reason (error or no bottle and source available). You can run the fetch script as follows:

```bash
aok@qe-monterey repos % /Volumes/Monterey/bin/fetch-from-file /Volumes/Monterey/repos/b5b2c1f838a_nodeps --window 50
Using input file: /Volumes/Monterey/repos/b5b2c1f838a_nodeps
Window size: 50 formulae per batch

Fetching bottles for lines 1 to 50 (50 formulae)...
  ✗ Failed: homebrew/core/alure
  → Retrying with 49 formulae...
    ✗ Failed: homebrew/core/bison@2.7
    → Retrying with 48 formulae...
```

Using the nodeps index since it's the shortest one but be forewarned it may take hours. The script will output progress as it fetches formulae in blocks from this index.

### Fetch vs. Install

Preemptive fetching was conducted for all formulae without dependencies to cache their bottles and some formulae failed to fetch. Here is a sample output from verifying bottles for all formulas without dependencies:

```bash
aok@qe-monterey repos % /Volumes/Monterey/bin/verify-from-file /Volumes/Monterey/repos/b5b2c1f838a_nodeps
Using input file: /Volumes/Monterey/repos/b5b2c1f838a_nodeps
Brew cache directory: /Volumes/Monterey/cache/Intel/homebrew-cache
Checking for missing bottles...

Building cache index...
Cache index built
alsa-lib
... (truncated for brevity) ...
xcinfo

Total formulas checked: 1385
Missing bottles: 132
Total time: 24 seconds
```

All packages without dependencies were preemptively fetched first. However, some fetches failed even though the bottles were available for installation.

Using fetch to preemptively download bottles sometimes fails, but the same install command downloads a bottle for the formula without having to build from source. The formula `tree` is one such example. Using `brew fetch tree` apparently failed, but `brew install tree` worked fine, downloading the bottle without building from source.

This behavior suggests that the fetch command may not always accurately reflect the availability of bottles for installation. Unfortunately, the exact reasons for the fetch failure was lost. I will retry this case again on a clean system after removing the cached bottle.

### Fixing Old Conditional Dependencies

The `texinfo` formula fails to pull a bottle on `fetch`, or on `install` nor does it build from sources with `install --build-from-source`. The issue stems from the conditional dependency `:high_sierra_or_older` which is no longer supported or recognized by Homebrew:

```ruby
  on_system :linux, macos: :high_sierra_or_older do
    depends_on "gettext"
  end
```

Removing it with `brew edit` will fix the issue and not create problems since `gettext` is only needed for Linux and systems older than `high_sierra` which Monterey is not: Monterey already has the necessary `gettext` functionality built-in via `uses_from_macos`. Here's how things looked:

```bash
aok@qe-monterey ~ % brew fetch texinfo
Error: homebrew/core/texinfo: Invalid OS condition: :high_sierra
aok@qe-monterey ~ % ls -l /Volumes/Monterey/cache/Intel/homebrew-cache/downloads/*texinfo*
zsh: no matches found: /Volumes/Monterey/cache/Intel/homebrew-cache/downloads/*texinfo*

# Fix by editing the formula to remove the offending conditional dependency
aok@qe-monterey ~ % brew edit texinfo
Editing /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/Formula/t/texinfo.rb
To test your local edits, run:
  brew install --build-from-source --verbose --debug texinfo

# Retry install or fetch after editing
aok@qe-monterey ~ % brew install texinfo
==> Fetching downloads for: texinfo
✔︎ Bottle Manifest texinfo (7.1)                            [Downloaded    9.3KB/  9.3KB]
✔︎ Bottle texinfo (7.1)                                     [Downloaded    2.0MB/  2.0MB]
==> Pouring texinfo--7.1.monterey.bottle.tar.gz
🍺  /usr/local/Cellar/texinfo/7.1: 494 files, 9.5MB
```

## Shared Storage

Using shared storage makes a lot of sense when dealing with Homebrew's large repositories and cached bottles (both downloaded and compiled from sources). Casks too can be cached in a similar manner on shared storage.
