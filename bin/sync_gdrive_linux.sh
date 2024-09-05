#!/bin/bash

rclone sync gdrive: /mnt/Data/CloudSync/gdrive -P --stats 1s -v
