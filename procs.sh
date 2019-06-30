#!/usr/bin/bash


## Usefull binary /usr/bin/lsof ‘LiSt Open Files’ is used to find out which files are open by which process:
## View files opened by a process  $(ls -l /proc/`pidof proccess`/fd) fd = file descriptor

#list processes that are using a certain file
lsof file_name

#list all files open by a process
lsof -p PID

#list procs of a certain user
$ lsof -u $(whoami)

#list procs of specific port
lsof -i TCP:22

#view process PPID PID GID similar output like $ pstree
ps ejf  

#view threads
ps -fL PID

