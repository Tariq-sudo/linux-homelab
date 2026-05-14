# Project: Automated Web Server Backups

## Overview
This project contains a Bash shell script (`backup_script.sh`) designed to automate the backup process of the web server directory. It creates a compressed archive of the `/var/www/html` directory and stores it in a specified backup folder, ensuring data is preserved with a date stamp.

## The Script (`backup_script.sh`)
The script defines the source and destination directories and performs the compression.

Bash

```bash
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
```

## How It Works
The script utilizes the following core Linux commands:

### 1. `mkdir -p`
The command `mkdir` is used to create directories.

*   **The** `-p` **flag:** This stands for "parents." It ensures that the command creates the directory if it does not exist. Crucially, if the directory **already** exists, it does not throw an error; it simply moves on. This makes the script safe to run repeatedly.
### 2. `tar -czf`
The command `tar` (Tape Archive) is used to compress the files.

* `-c` **(Create):** Tells the program to create a new archive file.
* `-z` **(Gzip):** Tells the program to compress the archive using gzip (reducing file size).
* `-f` **(File):** Allows us to specify the filename of the archive immediately after the flag.
### 3. `date +"%F"`
This generates a timestamp in the format `YYYY-MM-DD` (e.g., 2023-10-25). This ensures that every backup file has a unique name based on the day it was run, preventing old backups from being overwritten immediately.

## Automation with Cron
To automate this script so it runs without user intervention, we use the Cron scheduler.

## 1. Make the script executable
Before Cron can run the script, we must give it permission to execute:

Bash

```bash
chmod +x backup_script.sh
```
## 2. Edit the Crontab
Open the cron schedule editor:

Bash

```bash
crontab -e
```
## 3. Add the Job
To run this backup every day at 2:30 AM, add the following line to the bottom of the file:

Bash

```bash
30 2 * * * /home/labadmin/project-automated-backups/backup_script.sh
```
### Breakdown of the syntax:

* `30:` Minute (30)
* `2:` Hour (2 AM)
* `*:` Day of month (Every day)
* `*:` Month (Every month)
* `*:` Day of week (Every day)
