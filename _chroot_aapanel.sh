#!/bin/bash

while [ x$username = "x" ]; do

read -p "Please enter the username you wish to create : " username

if id -u $username >/dev/null 2>&1; then

echo "User already exists"

username=""

fi

done


while [ x$password = "x" ]; do

read -s -p "Please enter the password you wish to create : " password

if id -u $password >/dev/null 2>&1; then

echo "Password already exists"

password=""

fi

done


while [ x$group = "x" ]; do

read -p "Please enter the primary group. If group not exist, it will be created  [www]: " group

if id -g $group >/dev/null 2>&1; then

echo "Group exist"

else

groupadd $group

fi

done


while [ x$groupname = "x" ]; do

read -p "Please enter the secoundary group. If group not exist, it will be created [ssh] : " groupname

if id -g $groupname >/dev/null 2>&1; then

echo "Group exist"

else

groupadd $groupname

fi


done


read -p "Please enter bash [/bin/sh] : " bash

if [ x"$bash" = "x" ]; then

bash="/bin/sh"

fi

read -p "Please enter homedir [/home/$username] : " homedir

if [ x"$homedir" = "x" ]; then

homedir="/home/$username"

fi

read -p "Please confirm [y/n]" confirm

if [ "$confirm" = "y" ]; then

useradd -g $group -s $bash -d $homedir -m $username -p $(openssl passwd -1 $password) -G $groupname 
echo "AllowUsers $username" >> /etc/ssh/sshd_config
systemctl restart ssh

fi
