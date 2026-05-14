#!/bin/bash

# A simple script to backup the web server directory

TIMESTAMP=$(date +"%F")
BACKUP_DIR="/home/labadmin/backups"
SOURCE_DIR="/var/www/html"
ARCHIVE_FILE="web_backup_$TIMESTAMP.tar.gz"

# Create backup directory if it doesn't exist

mkdir -p $BACKUP_DIR

# Create the compressed archive

tar -czf $BACKUP_DIR/$ARCHIVE_FILE $SOURCE_DIR

echo "Backup of $SOURCE_DIR completed successfully to $BACKUP_DIR/$ARCHIVE_FILE"
