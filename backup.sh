#!/bin/bash
set -e
cd /home/asaf/homelab
source .env
BACKUP_DIR=${BACKUP_DIR:-/home/asaf/backups}
DATE=$(date +%F)
mkdir -p $BACKUP_DIR

# databases
docker compose exec -T db pg_dump --no-owner -U nextcloud nextcloud | gzip > $BACKUP_DIR/nextcloud-db-$DATE.sql.gz
docker compose exec -T app-db pg_dump --no-owner -U app app | gzip > $BACKUP_DIR/app-db-$DATE.sql.gz

# Uptime Kuma volume
docker run --rm -v uptime-kuma:/data -v $BACKUP_DIR:/backup alpine \
  tar czf /backup/uptime-kuma-$DATE.tar.gz -C /data .

# delete backups older than 7 days
find $BACKUP_DIR -name "*.gz" -mtime +7 -delete
