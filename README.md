### 101

* Agentless (uses as transport layer Open SSH)
* Configuration (`/etc/ansible/ansible.cfg`) check: `$ansible-config list`
* Ansible inventory commands: `$ansible-inventory --list` or `$ansible-inventory --graph`


### Ad-hoc commands

* Can be used to reboot servers, copy files, manage packages and users etc: `ansible <HOST_GROUP> -m <MODULE> -a "ARGUMENTS"`

Create an inventory/host file:
```
### host
[web] 
controller ansible_host=hostname ansible_connection=ssh ansible_user=user_name ansible_ssh_pass=user_password

[targets]
target1 ansible_host=192.168.0.59 ansible_user=user_name ansible_ssh_pass=user_password

#variables
[web:vars]
all_file = /tmp/direct_file

[targets:vars]
target_file = /tmp/target_file
```

* Ping `target1` machine using `ping` module, -v for verbose : `ansible target1 -v -m ping -i ~/host `
* Execute ad-hoc command using `command` module, -a for arguments: `ansible target1 -m command -a "who" -i ~/host` 
* Copy  file `.gitconfig` using `copy` module: `ansible target1 -m copy -a "src=/home/user/alex/.gitconfig dest=/tmp/.gitconfig" -i ~/host`
* Check the package manager on target machine using `setup` module: `ansible target_machine -m setup -a "filter=ansible_pkg_mgr" -i test_inventory `


* **flags** : for dry-run `--check` without making any changes e.g: `ansible target1 -m copy -a "src=test_file dest=/bin/test_file" --check --diff -i ~/host`, and in order to see the changes used `--diff` flag.


### Ansible playbook

1. Playbook = Single YAML file that describe the work-flow
2. Play = set of taks to be run on hosts
3. Task = action to be performed on host (execute a command, a module, run a script, install a package, restart the server) aka module

* Copy file to target machine using a simple playbook: `ansible-playbook -i ~/host dej.yml`

e.g of playbook dej.yml
```yml
# dej.yml
- name: Transfer file
  hosts: jenkins_machine
  tasks:
     - name: Transfer the script
       copy:
         src: test.py
         dest: /opt/data/jenkins/build
         owner: jenkins
         group: jenkins
         mode: '0660'
~                      
```

* Create file on target using file module within a playbook:`ansible playbook -i ~/host play_name.yml -e file_state=touch`  and passed the `{{file_state}}` variable from command line 

**play_name.yml**
```bash
-
  name: Play1
  hosts: all
  tasks:
    - name: Display resolv.conf contents
      command: cat resolv.conf chdir=/etc
    - name: Create a file on remote machine
      file:
        dest: /tmp/myfile
        state: '{{file_state}}'
      tags:
        - create-file
```
* Select play from playbook using tags:`ansible playbook -i hosts play_name.yml --tags create-file -e file_state=touch`  
! Also we can use `--skip-tags` flag     

* Playbook which uses variables from inventory to delete file from target:
**play_name.yml**
```bash
---
- hosts: target1
  tasks:
  - name: create a file via ssh
    file:
      dest: '{{target_file}}'
      state: absent
```

***

### Test/verify/lint playbooks

1) Dry Run using check module: `ansible-playbook foo.yml --check` or just syntax check it `ansible-module foo.yml --syntax-check`

2) Linter: ansible molecule to test your ansible roles: `pip install molecule`  

3) List playbook tags: `ansible-playbook --list-tags playbook.yml`
***

### Run Root

* Simplest way to run tasks as root is using the flag `-K` or`--ask-become-pass` e.g.: `ansible-playbook -i hosts install_jenkins.yml --ask-become-pass`  

* Configure the remote user that ansible uses, mainly this means `visudo` of `/etc/sudoers`, and add 
```
# Allow osboxes_user to run any commands anywhere
 osboxes_user ALL=(ALL:ALL) ALL

#Same thing without a password
%wheel ALL=(ALL) NOPASSWD: ALL
```
Also add the user to wheel group `$ usermod -aG wheel USERNAME`


### Cheat sheet


* To Set Up SSH Command: `sudo apt-get install openssh-server`
* To Copy the SSH Key on the Hosts `ssh-copy-id hostname`
* To Add Ansible repository `sudo apt-add-repository ppa:ansible/ansible`
* To Run the update command `sudo apt-get update`
* To Install Ansible package `sudo apt-get install ansible`
* To set up SSH agent
```
$ ssh-agent bash
$ ssh-add ~/.ssh/id_rsa
```

* To use SSH with a password instead of keys `ansible europe -a "/sbin/reboot" -f 20`
* To run /usr/bin/ansible from a user account `ansible europe -a "/usr/bin/foo" -u username`
* To run commands through privilege escalation and not through user account `ansible europe -a "/usr/bin/foo" -u username --become [--ask-become-pass]`
* To become a user, other than root by using `--become-user`:
* `$ ansible europe -a "/usr/bin/foo" -u username --become --become-user otheruser [--ask-become-pass]`
* To Transfer a file directly to many servers: `ansible europe -m copy -a "src=/etc/hosts dest=/tmp/hosts"`
* To change the ownership and permissions on files 
```
ansible webservers -m file -a "dest=/srv/foo/a.txt mode=600"

ansible webservers -m file -a "dest=/srv/foo/b.txt mode=600 owner=example group=example"
```
* To create directories `ansible webservers -m file -a "dest=/path/to/c mode=755 owner=example group=example state=directory"`
* To delete directories (recursively) and delete files  `ansible webservers -m file -a "dest=/path/to/c state=absent"`
* To ensure that a package is installed, but doesn’t get updated: `ansible webservers -m apt -a "name=acme state=present"`
* To ensure that a package is installed to a specific version: `ansible webservers -m apt -a "name=acme-1.5 state=present"`
* To ensure that a package is not installed: `ansible webservers -m apt -a "name=acme state=absent"`

* To ensure a service is started on all web servers: `ansible webservers -m service -a "name=httpd state=started"`

* To restart a service on all web servers: `ansible webservers -m service -a "name=httpd state=restarted"`

* To ensure a service is stopped: `ansible webservers -m service -a "name=httpd state=stopped`


##Command vs Shell

- With the **command** module the command will be executed without being proceeded through a shell. As a consequence some variables like $HOME are not available. And also stream operations like `<, >, | and & `will NOT work.
- The **shell** module runs a command through a shell, by default /bin/sh. This can be changed with the option executable. Piping and redirection are here therefor available.

