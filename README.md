# Apples TimeMachine Backups to BackInTime

## Tools used
* Linux machine
* Apple computer
* sshfs
* rsync

## Pre-Work
An apple computer is needed to read the backup from the (external) harddrive.
Linux can not read Apples file system, so we have to remount it for Linux.

## Steps to reproduce

* On Linux machine mount the remote Apple Time Machine Volume with sshfs (https://github.com/libfuse/sshfs)
```bash
sshfs user@machine:/Volumes/BACKUP /media/MOUNT_POINT
```
* The Apple Time Machine Backup is now mounted on the Linux machine. SSHFS does not support hardlinks, so we rebuild them with rsync's *link-dest*

* Adjust SRC and DST variable in shell script.

* **Always test the script with rsync's --dry-run parameter**

* Run script

## Inspired by
https://gist.github.com/tyzhnenko/d17b3cdc7ec6edf4164d788b552c1513#file-tmclone-sh
