SOURCE="/"
DEST="/backup"

# Remove backup files older than MAX_BACKUP_AGE. Use s, m, h, D, W, M, Y
MAX_BACKUP_AGE="1M"

printf "backing up $SOURCE to $DEST..."

# This will backup: $SOURCE - exclude.list + include.list
# Exclude DEST otherwise the backup will recursively loop.
rdiff-backup \
	--exclude $DEST \
	--include-globbing-filelist include.list \
	--exclude-globbing-filelist exclude.list \
	$SOURCE \
	$DEST

echo "finished\n"

# Remove old backups. --force is needed because rdiff-backup refuses to delete
# multiple old backups without the flag.
rdiff-backup --force --remove-older-than $MAX_BACKUP_AGE $DEST

printf "\n"

rdiff-backup --list-increments $DEST

echo "\nbackup size"

du -h -d 0 $DEST
