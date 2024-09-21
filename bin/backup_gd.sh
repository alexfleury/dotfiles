#!/bin/bash

# Some helpers and error handling.
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap "echo $( date ) Backup interrupted >&2; exit 2" INT TERM

# Close if borg or rclone is running.
if pgrep "borg" || pgrep "rclone" > /dev/null
then
    Info "Backup already running, exiting"
    exit
    exit
fi

# Setting this, so the repo does not need to be given on the commandline.
export BORG_REPO="/mnt/Data/CloudSync/proton/GDSaves"

info "Starting backup..."

# Backup the most important directories into an archive named after
# the machine this script is currently running on:

borg create                                      \
    --verbose                                    \
    --filter AMEx                                \
    --files-cache=mtime,size                     \
    --list                                       \
    --stats                                      \
    --show-rc                                    \
    --compression lz4                            \
    --exclude-caches                             \
                                                 \
    ::"grimdawn-{now}"                           \
    "/home/alex/.local/share/Steam/steamapps/compatdata/219990/pfx/drive_c/users/steamuser/Documents/My Games/Grim Dawn/save" \
    "/home/alex/GDStash"

backup_exit=$?

info "Pruning repository..."

# Use the `prune` subcommand to maintain d daily, w weekly and m monthly
# archives of THIS machine.

borg prune                  \
    --list                  \
    --prefix "grimdawn-"  \
    --show-rc               \
    --keep-daily    1       \
    --keep-weekly   1       \
    --keep-monthly  12      \
    --keep-yearly   3

prune_exit=$?

# Use highest exit code as global exit code.
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

# Execute rclone if no errors.
if [ ${global_exit} -eq 0 ];
then
    info "Backup, Prune and/or Compact finished sucessfully."
else
    info "Backup, Prune and/or Compact finished with an error."
fi

exit ${global_exit}
