#!/bin/sh

DESTDIR="/Volumes/VMs Backup 1 To"

[[ -e $DESTDIR ]] || exit

for vm in "$(find "/Users/laurent/Documents/Virtual Machines.localized/" -name *.vmwarevm)"; do
  "/Applications/VMware Fusion.app/Contents/Library/vmrun" -T fusion stop "$vm"
  rsync -av "$vm" "$DESTDIR/"
done
