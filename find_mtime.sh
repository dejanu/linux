#!/usr/bin/sh

# atime = access time
# mtime = modification time
# ctime = inode change time (system wise)

# sort ascending by size
# ls -lSh

# mtime switch last modified n*24 hours ago

# dirs older than 5 days (not modified in the past 5 days)
find . -type d -mtime +5 -exec rm {} \;


# dirs modified in the last 24 hours
find . -type d -mtime -24

# modified in the past hour
find . -type d -mtime -60


# create an archive with files older than 7 days and rm them if && aka $? -eq 0
find /path/to/folder/ -maxdepth 1 -type f -mtime +7 -print0 | tar -czf "/path/to/folder/$(date '+%Y-%m-%d').tar.gz" --null -T - && find /path/to/folder/ -maxdepth 1 -type f -mtime +7 -exec rm {} \; || echo "NOK"

