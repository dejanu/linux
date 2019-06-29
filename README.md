#Processes aka tasks

"In a basic form Linux processes can be vizualized as a running instance of a program"  
"Processes can talk to other processes using Inter process communication methods (dbus) and can share data using techniques like shared memory"

* Foreground (interactive processes) - they are init and controlled through a terminal session aka the user has to start the proccess
				     - to bring a process to foreground just run  ```bash fg &1```

	
* Background ( non-interactive/automatic processes) - they are not connected to the terminal , and do not expect any user input.


Display all running jobs
```shell
$ jobs
[1] Running sleep 500 & (wd: ~)
[2]- Running sleep 600 & (wd: ~)
[3]+ Running ./Fritzing &
```
To bring a process to foreground run `$ fg %2`  

& - control operator ( e.g: vim & or .\script.sh & ) the shell executes the command in the backround shell.
  - to create a job just append the control operator

Ctrl + Z - sends SIGSTOP signal to the process and suspends it.

-----------------------------------------------------------------------------------------------------
**Daemons** - backround processes that start at system startup. They can be controlled by the user via the __init__ process.
**init** - has PID of 1 it's the parent of all processes on the system (when linux boots up) and it is started by the kernel itself.
If somehow init daemon could not start, no process will be started and the system will reach a stage called “Kernel Panic“.  

**Systemd** -  is an INIT SYSTEM (other init systems: SysV, Upstart) and system manager it has become the default init system for many Linux distributions. A init replacement daemon designed to start process in parallel, implemented in a number of standard distribution – Fedora, OpenSuSE, Arch, RHEL, CentOS, etc.

 **systemd** gives us the `systemctl` management tool for controling the init system, which is mostly used to enable services to start at boot time. We can also start, stop, reload, restart and check status of services.

- systemd manages units (resources that system knows to operate/manage on)
- systemd categorize units based on the type of resource they describe ( .service, .socket, .device)  

e.g. : etc/systemd/system/docker.service = which describes how to manage docker service  

```bash
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network.target docker.socket
Requires=docker.socket

```
[systemdunits](https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files)

```bash
sudo systemctl enable service_name #start at boot time
systemctl status/start/stop/restat docker/httpd/mysql
systemctl list-units --type service --all
systemctl daemon-reload  #reload systemd manager configuration
```   

 ------------------------------------------------------------------------------


Processes are created through different system calls, most popular are fork() and exec()

1) System() Function 
2) fork() or exec() Function
  Fork: system call to Clone current process (the parent and the child are identical procceses). The cloned process has new PID
  Exec: Replace current program with a different one
  
  
  
  The fundamental way of controlling processes in Linux is by sending signals to them, to list all signals:
 
  kill -l (9 SIGKILL 2 SIGINIT 1 SIGHUP)
 
-----------------------------------------------------------------------------------------------------------------------------
Usefull binary /usr/bin/lsof ‘LiSt Open Files’ is used to find out which files are open by which process:


#list processes that are using a certain file
`$ lsof file_name`

#list all files open by a process
`# lsof -p PID`

#list procs of a certain user
`$ lsof -u $(whoami)`

#list procs of specific port
`# lsof -i TCP:22`


-----------------------------------------------------------------------------------------------------------------------------
Library modules "a way" for programs to share code.

>> man hier % view the file system hierachy 

.so = dynamically linked shared objects libraries (aka .dll from windows)
.a = static libraries

>> ldd /bin/ls  %view the dependencies modules for the particular command
