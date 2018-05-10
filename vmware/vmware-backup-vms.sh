#!/bin/sh


DESTDIR="/Volumes/VMs Backup 1 To"

[[ -e $DESTDIR ]] || exit

for vm in "$(find "/Users/laurent/Documents/Virtual Machines.localized" -name *.vmwarevm)"; do
   printf "Backup of %s\\n" "$vm"
    "/Applications/VMware Fusion.app/Contents/Library/vmrun" -T fusion stop "$vm" 2>&1 > /dev/null
  rsync -av "$vm" "$DESTDIR/"
done
