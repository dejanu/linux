#!/usr/bin/bash


## Usefull binary /usr/bin/lsof ‘LiSt Open Files’ is used to find out which files are open by which process:
## View files opened by a process  $(ls -l /proc/`pidof proccess`/fd) fd = file descriptor

# list processes that are using a certain file
lsof file_name

#list all files open by a process
lsof -p PID

# list procs of a certain user
$ lsof -u $(whoami)

# list procs of specific port
lsof -i TCP:22

#####################################################################################################################
# list process IDs of all processes that have one or more files open, works on dir also $fuser .
fuser /home/tecmint


#####################################################################################################################
# check which app based on PID
ls -l /proc | grep PID
ps --pid=PID

# view process PPID PID GID similar output like $ pstree
ps ejf  

# view threads or check $cat /proc/PID/status
ps -fL PID

# count threads or check $cat /proc/PID/status
ps -o thcount PID

# display running daemons 
ps -e   

# display all processes that run on terminals 
ps -a  

# display all processes that do not run on terminals
ps -x 


