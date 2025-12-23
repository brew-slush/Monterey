#!/bin/bash
set -x

DMG="/Volumes/Monterey/software/Intel/Command_Line_Tools_for_Xcode_14.2.dmg"

echo "=== File Check ==="
ls -la "${DMG}"
file "${DMG}"

echo "=== DMG Info ==="
hdiutil imageinfo "${DMG}" 2>&1 | head -20

echo "=== Current Mounts ==="
mount | grep -i command || true
hdiutil info | grep -i command || true

echo "=== Mount Attempt ==="
hdiutil attach -readonly -nobrowse "${DMG}" -mountpoint "/tmp/test_mount_$$" 2>&1

echo "=== Result ==="
ls "/tmp/test_mount_$$" 2>&1 || echo "Mount failed"
hdiutil info | grep "/tmp/test_mount"
