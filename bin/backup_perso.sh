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
export BORG_REPO="/run/media/alex/HDD_1TB/Backups"

# Setting this, so you won"t be asked for your repository passphrase.
export BORG_PASSPHRASE=$(<~/.borg_pass)

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
    --exclude "/mnt/Data/SteamLibrary"           \
    --exclude "/mnt/Data/Series/mp4"             \
    --exclude "/mnt/Data/Films/mp4"              \
    --exclude "/mnt/Data/Audio/Musique/MP3"      \
    --exclude "/mnt/Data/CloudSync"              \
                                                 \
    ::"{hostname}-{now}"                         \
    "/mnt/Data"

backup_exit=$?

info "Pruning repository..."

# Use the `prune` subcommand to maintain d daily, w weekly and m monthly
# archives of THIS machine. The "{hostname}-" prefix is very important to
# limit prune"s operation to this machine"s archives and not apply to
# other machines" archives also:

borg prune                          \
    --list                          \
    --glob-archives "{hostname}-*"  \
    --show-rc                       \
    --keep-daily    1               \
    --keep-weekly   1               \
    --keep-monthly  12              \
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
