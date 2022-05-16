#!/bin/bash -ex
#
# Backup family file share to S3

TZ=UTC
# s3fs filesystem, backed by bucket 18c99540-161d-4396-a54d-9824a659024d in us-west-2
dest=/mnt/18c99540-161d-4396-a54d-9824a659024d

function finish {
  echo unmounting
  sudo /usr/bin/umount ${dest}
}
trap finish EXIT

if ! /usr/bin/findmnt ${dest}; then
    echo mounting
    sudo /usr/bin/mount ${dest}
fi

backup_date=$(date --iso-8601=minutes)

echo creating backup ${backup_date}
# sudo to ensure access to all files
sudo /usr/bin/borg --show-rc create --stats "${dest}::${backup_date}" /mnt/Family

# Delete old backups
oldest_backup_to_keep=$(date --date="${backup_date} -30 days" --iso-8601=minutes)
echo keeping backups younger than ${oldest_backup_to_keep}

for backup in $(/usr/bin/borg list ${dest} | cut --fields=1 --delimiter=' '); do
    if [[ -n ${backup} && -n ${oldest_backup_to_keep} \
              && ${backup} < ${oldest_backup_to_keep} ]]; then
        echo deleting $backup
        /usr/bin/borg delete ${dest}::${backup}
    fi
done
