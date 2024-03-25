#!/bin/bash


# Close if borg or rclone is running.
if pgrep "borg" || pgrep "rclone" > /dev/null
then
    Info "Backup already running, exiting"
    exit
    exit
fi


# Setting this, so the repo does not need to be given on the commandline.
export BORG_REPO="/mnt/w/Backups"

#This is the location you want Rclone to send the BORG_REPO to
#export CLOUDDEST="gdrive:/Backups"

# Setting this, so you won't be asked for your repository passphrase.
export BORG_PASSPHRASE=$(<~/.borg_pass)

# Some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM


info "Starting backup..."

# Backup the most important directories into an archive named after
# the machine this script is currently running on:

borg create                     \
    --verbose                   \
    --filter AMEx               \
    --files-cache=mtime,size    \
    --list                      \
    --stats                     \
    --show-rc                   \
    --compression lzma,9        \
    --exclude-caches            \
    --exclude /mnt/d/SteamLibrary \
    --exclude /mnt/d/Series/mp4 \
    --exclude /mnt/d/Films/mp4  \
    --exclude "/mnt/d/'$RECYCLE.BIN'" \
    --exclude "/mnt/d/System Volume Information" \
                                \
    ::'{hostname}-{now}'        \
    /mnt/d

backup_exit=$?


info "Pruning repository..."

# Use the `prune` subcommand to maintain d daily, w weekly and m monthly
# archives of THIS machine. The '{hostname}-' prefix is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:

borg prune                  \
    --list                  \
    --prefix '{hostname}-'  \
    --show-rc               \
    --keep-daily    1       \
    --keep-weekly   1       \
    --keep-monthly  12      \
    --keep-yearly   3

prune_exit=$?


# Use highest exit code as global exit code.
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

# Execute rclone if no errors.
#if [ ${global_exit} -eq 0 ];
#then
#    info "Rclone Borg sync has started..."
#    rclone sync $BORG_REPO $CLOUDDEST -P --stats 1s -v
#    info "Rclone Borg sync completed."
#else
#    info "Backup, Prune and/or Compact finished with an error."
#fi

exit ${global_exit}
