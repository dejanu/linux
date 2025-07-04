# Everything is a file design

- Files are files, devices drivers are files, directories, system configuration, kernel parameters, and... even processes are all represented as files on the filesystem. 
- Main advantage of Everything is a file design, is that the same tools that can be used for files can also interact with other devices (network or pipes) or entities (processes)
- Everything, whether a plain-text file (e.g.,`/etc/hosts`), a block or character special device driver (for example, `/dev/sda`), or kernel state and configuration (for example, `/proc/cpuinfo`) is represented as a file.

```bash
# let's check how my shell was started, using the PID of the current process, and leveraging everything is a file design
ls -l /proc/$$/cmdline

# let's check the file descriptors of it
ls -l /proc/$$/fd
```
- Everything is a file...this includes deleted files that now live as chunks of memory that are in use by a process, soo sometimes `df will report bigger disk usage than du`
- Each file is represented by a **inode** (data structure that stores all the information about the file e.g. permissions, file-type, owner; except its name and actual data). To check the inode of a file `ls -i /etc/passwd`
---
# Each command does one thing very well

- finding things is very easy:
```bash
# where type can be d(directory) c(character special file), b(block special file), l(symbolic ink), p(named pipe), s(socket), f(normal file)
find -type <d/c/b/l/p/s/f>
```
- measuring things is very easy, disk usage `du` and at the file-system level `df`, for example:
```bash
# Calculate size of each of the system top-level dirs
 du --max-depth=1 -hx /
```
---
# Pipelines allow composition

- anything that can read or write can be composed. For any process we have three standard file things: what it can read (stdin) and the where it can write (stdout and stderr)

# The shell is the gateway to Everything 
- we have sh (Bourne shell) , chs (C shell), bash (Bourne-again shell), ksh (Korn shell) and last but not least zsh  

---
# Everything running is a process

## Processes aka tasks

- In a basic form, Linux processes can be visualised as a running instance of a program  
- Processes can talk to other processes using Inter process communication methods (dbus, sockets, signals, pipes) and can share data using techniques like shared memory   
- Every process is started by a parent, except **init** process which is started by the Linux kernel and has PID of 1, check:
```bash
# check the process with PID 1
ps -p 1

# it can be systemd or Upstart, or if it is init it might be a simlink to Upstart or systemd otherwhise is certain that you have SysV init
ls -l /sbin/init 
```
* Foreground (interactive processes) - they are init and controlled through a terminal session aka the user has to start the proccess
				     - to bring a process to foreground just run  `fg %1`

	
* Background ( non-interactive/automatic processes) - they are not connected to the terminal , and do not expect any user input.


Display all running jobs
```shell
$ jobs
[1] Running sleep 500 & (wd: ~)
[2]- Running sleep 600 & (wd: ~)
[3]+ Running ./Fritzing &
```
To bring a process to foreground run `$ fg %2`  

`&` - control operator ( e.g: vim & or .\script.sh & ) the shell executes the command in the backround shell, to create a **job** (command or a task that is up and running but hasn't yet finished and it's managed by the shell) just append the **control operator** . 

Ctrl + Z - suspends/stops the running process sending SIGSTOP signal to the process and SUSPENDS it  
Ctrl + C - terminate/intrerrupts the running process by sending `SIGINT 2`  signal

Signals are a fundamental way to control linux processes. 
A process cannot send a signal to another process it must ask the kernel to send the signal via a sys-call .  
The `kill` command allows you to send a signal to any application.  Usage `$ kill -9 PID` (or signal number is not given SIGTERM -15 is the default one): 

```bash
kill -l
 1) SIGHUP	 2) SIGINT	 3) SIGQUIT	 4) SIGILL
 5) SIGTRAP	 6) SIGABRT	 7) SIGEMT	 8) SIGFPE
 9) SIGKILL	10) SIGBUS	11) SIGSEGV	12) SIGSYS
13) SIGPIPE	14) SIGALRM	15) SIGTERM	16) SIGURG
17) SIGSTOP	18) SIGTSTP	19) SIGCONT	20) SIGCHLD
21) SIGTTIN	22) SIGTTOU	23) SIGIO	24) SIGXCPU
25) SIGXFSZ	26) SIGVTALRM	27) SIGPROF	28) SIGWINCH
29) SIGINFO	30) SIGUSR1	31) SIGUSR2
```
SIGINT ("weakest Ctrl+C") < SIGTERM (15 allows aplication to exit cleanley) < SIHUP (automatically sent to applications running in terminal when user disconnects from that terminal) < SIGQUIT (3 create core dump). 


```bash
# trap ctrl-c aka SIGINT and call ctrl_c() function

trap ctrl_c 2

function ctrl_c() {
        echo "** Trapped CTRL-C"
}


# trap crtl-z aka SIGTSTP and call ctrl_c() function

trap ctrl_z 20

function ctrl_z(){
        echo "**Trapped CTRL-Z"
}
``` 

Using `&` causes the program to run in the background, so you'll get a new shell prompt instead of blocking until the program ends. `nohup` and `disown` are largely unrelated; they suppress `SIGHUP` (hangup) signals so the program isn't automatically killed when the controlling terminal is closed.   

`nohup` - run a command immune to hangups 
`disown` - remove a job from the table of active jobs for the current shell. It is useful when you want to end a background process without killing it

`nohup` do this when the job first begins. If you don't nohup a job when it begins, you can use `disown` to modify a running job; with no arguments it modifies the current job, which is he one that was just backgrounded.
```bash
nohup sleep 100 &
jobs
# will return
# [1]+  Running                 nohup sleep 100 &
disown %1
jobs
# the job will not be in the table of active jobs
```
-----------------------------------------------------------------------------------------------------
**Daemons** - backround processes that start at system startup. They can be controlled by the user via the __init__ process (e.g. sshd which is started by the init process when it executes the sshd init script).


**init** - has PID of 1 it's the parent of all processes on the system (when linux boots up) and it is started by the kernel itself.` /sbin/init`
If somehow init daemon could not start, no process will be started and the system will reach a stage called “Kernel Panic“. 

```bash

 ps -l 1
  UID   PID  PPID        F CPU PRI NI       SZ    RSS WCHAN     S             ADDR TTY           TIME CMD
    0     1     0     4004   0  37  0  4374844  13372 -      Ss                  0 ??         9:23.82 /sbin/launchd
```

**Systemd** -  is an INIT SYSTEM (other init systems: SysV init or Upstart) and system manager it has become the default init system for many Linux distributions. A init replacement daemon designed to start process in parallel, implemented in a number of standard distribution – Fedora, OpenSuSE, Arch, RHEL, CentOS, etc.

 **systemd** gives us the `systemctl` management tool for controling the init system, which is mostly used to enable services to start at boot time. We can also start, stop, reload, restart and check status of services.

- systemd manages units (resources that system knows to operate/manage on)
- systemd categorize units based on the type of resource they describe (.service, .socket, .device)  

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
sudo systemctl enable service_name # start at boot time
systemctl status/start/stop/restart docker/httpd/mysql
systemctl list-units --type service --all
systemctl daemon-reload  #reload systemd manager configuration
```   


- `systemctl` is the main utility to control daemons/services in `systemd` , while the `service` command is the traditional utility in `SysVinit` world . 

-----------------------------------------------------------------------------------------------------------------------------

**Socket** (endpoint for communication - bidirectional communication channel) can use clinet-server model (90% of time) or Peer-to-Peer

Are used for Inter Process Communication and can be:

        - Local (`AF_UNIX or AF_LOCAL`): between processes on the same host (Docker,systemd,PostgreSQL)
        - Network-based (`AF_INET`): between processes across the network (webservers)

**AF_UNIX** (domain) socket, instead of binding to an IP:PORT, you bind to file. UNIX sockets are faster and more secure for local IPC.
**AF_UNIX** (domain) socket are faster than TCP/IP for local IPC (no need for networking stack)

```bash
## in different terminal session create a server and a client and use socket
## over loopback network interface

# the SERVER must bind(), listen() and accept()
nc -l 12345

# the CLIENT
nc localhost 12345
```

-----------------------------------------------------------------------------------------------------------------------------

Processes are created through different **system calls** (routine call designated to transition from USER space to KERNEL space), most popular are **fork()** and **exec()**:

1) system()  
2) fork() - original parent process keeps running while the child process starts or exec() original parent process terminates and child parent inherits the process ID of the parent :


   Fork: system call to CLONE/DUPLICATE the current/calling process (the parent and the child are identical procceses). The cloned process has new PID, fork() takes no args and returns the PID of the child proccess.
   
   Exec: Replaces current program with a with a new process 
  
  We opened bash process and when we execute ls comand, behind fork() is called to clone the bash process and then exec() is called to
  replace the bash process with the new ls process
  ```shell
  $ls -l
  ```
  vs  
  
  ```shell
  $exec ls -l
  ```
  process completed and the terminal will close.   
  
 * If you run `ls`, your shell process will start up another process to run the `ls` program, then it will wait for it to finish. When it finishes, control is returned to the shell. with `exec ls`, you actually replace your shell program in the current process with the ls program so that, when it finishes, there's no shell waiting for it.  
 
 * When the user types a command in the shell a new process is created (using **fork** from the user's login shell then the command is loaded onto child process space via **exec** system call)

* Whenever we run any command in a Bash shell, a **subshell** is created by default, and a new child process is spawned (forked) to execute the command. When using **exec**, however, the command following exec replaces the current shell. This means no subshell is created and the current process is replaced with this new command
 
-----------------------------------------------------------------------------------------------------------------------------

**List files opened by a proccess**:

`lsof -p PID` equivalent more or less with `ls -l /proc/PID/fd` . 

`lsof` will also give you memory mapped `.so`-files - which technically isn't the same as a file handle the application has control over. `/proc/<pid>/fd` is the measuring point for open file descriptors
 

**pid** and **lock** files:

- pid files are written by some programs to record their process ID while they are **starting**. (Apache HTTPD may write its main process number to a pid file) 
- daemons needs the pid of the scripts that are currently running in the background to send them so called signals. Daemons uses the `TERM` signal to tell the script to exit when you issue a stop command.
- the usual location of pid files is `/var/run/`
- usage for pid files `cat filename.pid | xargs kill`


* Every process has a file descriptor associated with it, a process can open all sort of files like /dev files , UNIX Sockets, Network sockets, Library files /lib /lib64 
 
```shell
lsof -p <PID>
lsof -a -p <PID>
```
or
```shell
cd /proc/<PID>/fd
```

------------------------------------------------------------------------------------------------------------------------------
**Load Avg** vs **System Load - CPU utilization/usage**

1) Load is simply a count of the number of processes USING or WAITING for the CPU at a single point in time . The load is taken from `/proc/loadavg` text file containing load average , formula `loadvg = tasks running + tasks waiting (for cores) + tasks blocked`. 

- Load how many actively running (not sleeping) processes are using the CPU should be direct proportional with the no of CPU's (cores if multicore).

- for load use `$uptime` or `$top` + `l` or `$sar` or `$vmstat 1 10` (detailed view of memory stats)


2) CPU usage/utilization the ratio (usually expressed as a percentage)of time that the CPU is BUSY DOING STUFF. This measure only makes sense if you know over which period the percentage is being calculated

- summary of memory usage: `$ free -m` or `$ cat /proc/meminfo` to see swap space used/available , total usable RAM

- check no of CPU's (a single CPU can carry a single task at a time -> multi-processor vs multi-core): 
```bash
$ nproc
$ lscpu
$ cat /proc/cpuinfo
```

----------------------------------------------------------------------------------------------------------------------------

Library/modules "a way" for programs to share code.

>> man hier % view the file system hierachy 

.so = shared libraries/objects  (aka dynamically linked .dll from windows) (code is inserted at **run time**). 
Check which shared libraries an executable requires (view the dependencies modules for the particular command): `$ ldd /bin/ls`.  
The linker will first search any directories specified in the environment variable `LD_LIBRARY_PATH`,

.a = static libraries (code is inserted at **compile time**)


executing a file `. ./config.sh`  does not make any changes in the current shell, if intended, whereas the sourced file `source config.sh` makes the changes in the current shell itself.

----------------------------------------------------------------------------------------------------------------------------
*TTY* - terminal session connected to standard input
- `pts` Pseudo terminals e.g SSH
```bash
# check users
w

# check current tty
tty

# kill tty
pkill -9 -t pts/<NO>
```

----------------------------------------------------------------------------------------------------------------------------

* Shebang: `#!/usr/bin/env python`

* The EXEC system call understands shebangs natively
```bash
# if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!')) reads the very first bytes of the file, and compares them to #!
# if comparison is True the Linux kernel, which makes another exec call with path /usr/bin/env python and current file as the first argument
```
