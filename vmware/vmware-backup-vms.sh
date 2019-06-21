#!/bin/sh

DESTDIR="/Volumes/VMs Backup 1 To"

[[ -e $DESTDIR ]] || exit

function backup() {
  local vm=$1
  printf "Backup of %s to $DESTDIR\\n" "$vm"
  "/Applications/VMware Fusion.app/Contents/Library/vmrun" -T fusion stop "$vm" 2>&1 >/dev/null
  rsync -av "$vm" "$DESTDIR/"
}

find /Users/laurent/Virtual\ Machines.localized -name "*.vmwarevm" | while read file; do backup "$file"; done

