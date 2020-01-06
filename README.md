# Processes aka tasks

- In a basic form Linux processes can be vizualized as a running instance of a program  
- Processes can talk to other processes using Inter process communication methods (dbus, sockets, signals) and can share data using techniques like shared memory   
- Every process is started by a parent, except init process which is started by the linux kernel and has PID of 1  



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

`&` - control operator ( e.g: vim & or .\script.sh & ) the shell executes the command in the backround shell, to create a **job** ( command or a task that is up and running but hasn't yet finished) just append the **control operator** . 


Ctrl + Z - suspends proceess running in foregroud by sending SIGSTOP signal to the process and SUSPENDS it .  
Ctrl + C - terminate the process by sending SIGINT signal aka Intrerrupt signal.  


Signals are a fundamental way to control linux processes .  
The `kill` command allows you to send a signal to any application.  Usage `$ kill -TERM PID` . 

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
-----------------------------------------------------------------------------------------------------
**Daemons** - backround processes that start at system startup. They can be controlled by the user via the __init__ process.  

**init** - has PID of 1 it's the parent of all processes on the system (when linux boots up) and it is started by the kernel itself.` /sbin/init`
If somehow init daemon could not start, no process will be started and the system will reach a stage called “Kernel Panic“. 

``bash
 ps -l 1
  UID   PID  PPID        F CPU PRI NI       SZ    RSS WCHAN     S             ADDR TTY           TIME CMD
    0     1     0     4004   0  37  0  4374844  13372 -      Ss                  0 ??         9:23.82 /sbin/launchd
    

```

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

-----------------------------------------------------------------------------------------------------------------------------


Processes are created through different system calls, most popular are **fork()** and **exec()**:

1) System() Function 
2) fork() or exec() Function
  Fork: system call to Clone current process (the parent and the child are identical procceses). The cloned process has new PID, 
  Exec: Replace current program with a with a new process 
  
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
  
  If you run ls, your shell process will start up another process to run the ls program, then it will wait for it to finish. When it finishes, control is returned to the shell.w ith exec ls, you actually replace your shell program in the current process with the ls program so that, when it finishes, there's no shell waiting for it.  
  
  

 
-----------------------------------------------------------------------------------------------------------------------------
`bash $ps -e` = display running daemons   
`bash $ps -a` = display all processes that run on terminals   
`bash $ps -x` = display all processes that do not run on terminals

-----------------------------------------------------------------------------------------------------------------------------
Library modules "a way" for programs to share code.

>> man hier % view the file system hierachy 

.so = dynamically linked shared objects libraries (aka .dll from windows)
.a = static libraries

>> ldd /bin/ls  %view the dependencies modules for the particular command
