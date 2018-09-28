#Processes 
"In a basic form Linux processes can be vizualized as a running instance of a program"  
"Processes can talk to other processes using Inter process communication methods (dbus) and can share data using techniques like shared memory"

* Foreground (interactive processes) - they are init and controlled through a terminal session aka the user has to start the proccess
* Background ( non-interactive/automatic processes) - they are not connected to the terminal , and do not expect any user input

**Daemons** - backround processes that start at system startup. They can be controlled by the user via the __init__ process.
**init** - has PID of 1 it's the parent of all prcesses on the system (when linux boots up) and it is started by the kernel itself.
**Systemd** -  is an init system and system manager ithas become the default init system for many Linux distributions

The central management tool for controling the init system (manage service, check statuses, change system states)

```bash
systemctl 
```
 https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units
 
FYI:

& - control operator ( e.g: vim & or .\script.sh & ) the shell executes the command in the backround shell.
Ctrl + Z - sends SIGSTOP signal to the process and suspends it.


Creating processes :

1) System() Function 
2) fork() or exec() Function
  Fork: system call to Clone current process (the parent and the child are identical procceses). The cloned process has new PID
  Exec: Replace current program with a different one
  
  
  
  The fundamental way of controlling processes in Linux is by sending signals to them, to list all signals:
 
  kill -l (9 SIGKILL 2 SIGINIT 1 SIGHUP)

-----------------------------------------------------------------------------------------------------------------------------
Library modules "a way" for programs to share code.

>> man hier % view the file system hierachy 

.so = dynamically linked shared objects libraries (aka .dll from windows)
.a = static libraries

>> ldd /bin/ls  %view the dependencies modules for the particular command
