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


