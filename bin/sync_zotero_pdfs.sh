#!/bin/bash

rclone sync ~/Work/01_Biblio/PDFs gdrive:Zotero_PDFs -P --stats 1s -v
