#!/bin/bash

RSYNC=/usr/bin/rsync
RSYNC_ARGS="--protect-args --recursive --times --devices --specials \
  --hard-links --human-readable --links --acls --perms \
  --group --owner --no-inc-recursive -v --exclude-from=exclude.txt"

SRC="/smth/like/TimeMachine_BACKUP" # ADJUST!!!
TAIL_SRC="Macintosh HD/Users/"

DST="/where/your/backintime/backups/are" # ADJUST!!!
TAIL_DEST="backup/home"

BDIR="Backups.backupdb"

MACHINE_NAME=$(ls -d $SRC/$BDIR/*)
MACHINE_NAME=$(basename "$MACHINE_NAME")

RUN_RSYNC="$RSYNC $RSYNC_ARGS"

for folder in $SRC/$BDIR/$MACHINE_NAME/*; do
        echo "Add folder $folder to queue"
        SRC_DATES="$SRC_DATES $(basename "$folder")"
done

first=true
for curr in $SRC_DATES; do

    FULL_SRC="$SRC/$BDIR/$MACHINE_NAME/$curr/$TAIL_SRC"

    # really ugly code -- no idea how to make it better
    a=(`echo $curr | sed -e 's/[:-]/ /g'`)
    FULL_DST="$DST/${a[0]}${a[1]}${a[2]}-${a[3]}-000/$TAIL_DEST"

    mkdir -p $FULL_DST

    echo "Sync $curr folder"
    echo "You can find progress in log file sync_log_$curr"

    if [ "$first" = true ]; then
        echo $RUN_RSYNC "${FULL_SRC}" "${FULL_DST}" 2\>\&1 \> sync_log_$curr
        $RUN_RSYNC "${FULL_SRC}" "${FULL_DST}" 2>&1 > sync_log_$curr
        prev="${FULL_DST}"
        first=false
        continue
    fi
    echo $RUN_RSYNC --link-dest=$prev "${FULL_SRC}" "${FULL_DST}" 2\>\&1 \> sync_log_$curr
    $RUN_RSYNC --link-dest=$prev "${FULL_SRC}" "${FULL_DST}" 2>&1 > sync_log_$curr
    prev="${FULL_DST}"
done
