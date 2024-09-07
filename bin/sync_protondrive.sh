#!/bin/bash

rclone bisync proton: /mnt/Data/CloudSync/proton --create-empty-src-dirs --compare size,modtime,checksum --slow-hash-sync-only --resilient -MvP --drive-skip-gdocs --fix-case
