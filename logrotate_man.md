### LogRotate

- Script `/etc/cron.daily/logrotate` which calls the system binary `/usr/bin/logrotate`

- Directory `/etc/logrotate.d/` for logrotate configurations (e.g `logrotate.conf`)

- E.g. logrotate for tomcat apache catalina/localhost logs:

New configuration `logrotate.conf` 
```
/data/apache-tomcate/logs/localhost*.* {

# truncate the original log file in place after creating a copy
copytruncate

# rotate the log 
daily

missingok

# rotate if file size is greater than
size 5M

# rotate the original file and create a new file with permissions
create 664 <user> <group>

#keep only 7 recent rotated log files
rotate 7
}
```
- call logrotate : `/usr/sbin/logrotate -s </path/to/status_file> /path/to/logrotate.conf`
```

- https://www.digitalocean.com/community/tutorials/how-to-manage-logfiles-with-logrotate-on-ubuntu-16-04
