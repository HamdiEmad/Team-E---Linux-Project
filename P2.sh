#!/bin/bash

RETENTION_DAYS=7
BACKUP_DIR=""
BACKUP_TARGETS=()

read -p "Enter backup destination folder: " BACKUP_DIR
mkdir -p "$BACKUP_DIR"

echo "Enter directories to backup :"
read -a BACKUP_TARGETS

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_NAME="backup_$TIMESTAMP.tar.gz"
ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"

echo "Creating backup..."
tar -czf "$ARCHIVE_PATH" "${BACKUP_TARGETS[@]}"
echo "Backup created: $ARCHIVE_PATH"

echo "Cleaning up old backups..."
find "$BACKUP_DIR" -type f -name "backup_*.tar.gz" -mtime +$RETENTION_DAYS -exec rm {} \;

echo "Do you want to sync this backup to Google Drive? (y/n)"
read GDRIVE_CHOICE
if [[ "$GDRIVE_CHOICE" == "y" ]]; then
    echo "Uploading to Google Drive... (requires rclone setup)"
    rclone copy "$ARCHIVE_PATH" gdrive:/Backups/
    echo "Backup uploaded to Google Drive."
fi

echo "Available backups:"
ls -lh "$BACKUP_DIR"

echo "Backup process complete!"

