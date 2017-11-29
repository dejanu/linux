#!/usr/bin/bash

echo -n "User: "
read user

echo -n "Password: "
read -s password

ftp -in localhost << gata
user $user $password
ls -l
bye
gata
