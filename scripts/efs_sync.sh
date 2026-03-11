#!/bin/bash
# EFS to S3 Near Real-Time Sync Script

EFS_PATH="/share/projects"
S3_BUCKET="s3://YOUR_BUCKET_NAME"
LOG_FILE="/var/log/efs-sync.log"

aws s3 sync "$EFS_PATH" "$S3_BUCKET"
