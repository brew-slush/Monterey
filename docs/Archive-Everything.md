# Archive Everything

Brew uses the environment variable `HOMEBREW_CACHE` to determine where to store downloaded bottles and casks. By default, this is set to `~/Library/Caches/Homebrew`.

Brew slushy, changes this to a different location, such as a shared storage directory, to optimize storage and access across multiple systems while archiving all bottles and casks for future use.

## Bottle Prefetching and Archiving

There's little to no benefit to caching or prefetching bottles on a single machine that uses a supported version of Homebrew. Supported versions regularly update their bottles making older versions obsolete. With many Apple machines on a LAN, using a cache makes sense to avoid redundant downloads: very useful for enterprise brew deployments. This however is not the case for frozen unsupported versions of Homebrew.

### Prefetching All Bottles

Frozen versions of brew only ever reference one version of each bottle which never changes: the entire point of the freeze. Unsupported versions of Homebrew are at serious risk of losing access to bottles over time as its repositories evolve. The further down the line you attempt to install a package, the higher the likelihood that the bottle will no longer be available upstream. Even source bundles may be removed or relocated.

Prefetching and caching all available bottles for a frozen version of Homebrew ensures that you have access to the necessary packages even if they are no longer available upstream. You're effectively creating an archive of all bottles for that frozen version of Homebrew. The cache is no longer a cache but an archive and you're future proofing against loss of access to bottles and source bundles.

### Know What's Missing Early

You also want to know immediately what you may have to build from source because the bottle is no longer available upstream. By prefetching all available bottles, you can identify which ones are missing from your cache. This allows you to proactively build and cache those missing bottles from source, ensuring that you have a complete set of bottles for future installations.

Sometimes, one missing bottle can prevent the installation of an entire dependency tree. Knowing what is missing ahead of time allows you to address these gaps proactively. Don't wait until you need to install a package to find out that its bottle is missing and you have to chase down source repositories online if available. The situation is a nightmare.

### Other Benefits

1. Speed: Installing from a local cache is significantly faster than downloading from the internet, especially for large bottles or in environments with slow internet connections.
2. Bandwidth Savings: By caching bottles locally, you reduce the need to repeatedly download the same bottles, saving bandwidth and reducing load on external servers.
3. Offline Installations: A local cache allows for installations even when there is no internet connectivity, which can be crucial in certain environments.
4. Reducing Repeat Builds: Some formulas may require building from source if bottles are not available. Missing bottles become certain after fetching all bottles. Once missing bottles are identified they can be built and kept archived in the cache. Having a local cache of built bottles speeds up future installations of those formulas and reduces the need for repeat builds.

### Storage Tradeoffs

Even if bottle and cask hording equates to terabytes of storage, it is still worth it for the above reasons. Storage is cheap, and the benefits of having a complete time capsule frozen in time outweigh the space costs. If you're able to pull down all bottles or complete the entire set by building missing bottles consider yourself very lucky.

Cache sizes for Monterey brew-slush at b5b2c1f838a:

- Formulae with no dependencies (true leaves): ~6 GB
- Full formulae set: ~50 GB
- Full casks set: ~1 TB

This might sound like a lot, but consider the alternative: having to build everything from source because bottles are no longer available upstream. The time, effort, and potential for failure far outweigh the cost of storage.

A multi-terabyte shared storage solution or just a couple terabyte attached external USB drive is a small price to pay for the peace of mind and convenience of having a complete archive of bottles and casks for a frozen version of Homebrew.
