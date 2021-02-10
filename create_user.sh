## UBUNTU Create user and add it to all groups

## list users
getent passwd | cut -d':' -f1

## view groups for user
groups
groups cs10fh
id cs10fh

## ------delete user-------
$sudo userdel -r john
$sudo pkill -9 -u john

## ---create user----------

# low level command, the user's shell will point to /bin/sh and not to /bin/bash so it will not have autocomplete
$ useradd us81jt

# you can change the shell and also want to copy /etc/skel/.bashrc to the user's home directory.
$ sudo -u $USERNAME chsh -s /bin/bash


# change passwd
$ passwd  us81jt (us81jt)

# make ~ for user
$mkdir /home/us81jt
$mkhomedir_helper us81jt
$sudo chown us81jt:us81jt /home/us81jt


# OR OR instead you can use
#  will default to using /bin/bash as the shell and seed the new user's home directory with the files from /etc/skel/
$ adduser

# add user to groups
$ usermod -aG sudo,docker,vboxsf .. us81jt

# create user without interactive shell
$ sudo useradd john -s /sbin/nologin

