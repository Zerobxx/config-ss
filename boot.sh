#!/bin/bash
# init the ss hosts when created

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin;
export PATH


# increase the num of file descriptor
if ! grep '^ulimit -n 51200' ~/.profile; then
    echo 'ulimit -n 51200' >> ~/.profile
    source ~/.profile
fi

# config ssh can only use public key to log in
function config_ssh(){
    
    # disable passowrd
    if grep '^PasswordAuthentication' /etc/ssh/sshd_config; then
        sed -re 's/^(PasswordAuthentication)([[:space:]]+)yes/\1\2no/' -i.`date -I`.passowrd /etc/ssh/sshd_config
    else
        echo PasswordAuthentication no >> /etc/ssh/sshd_config
    fi
    
    # change default ssh port
    if grep '^Port' /etc/ssh/sshd_config; then
        sed -re 's/^(Port)([[:space:]]+)[0-9]+/\1\21234/' -i.`date -I`.sshport /etc/ssh/sshd_config
    else
        echo Port 1234 >> /etc/ssh/sshd_config
    fi    
    
    # input the public keys
    if [ ! -d "~/.ssh" ]; then
        mkdir ~/.ssh
    fi
    
    cd ~/.ssh
    mv /home/config-ss/pub_key authorized_keys
    chmod 600 authorized_keys
    service sshd restart
    
}

# install git
function check_git(){
  if ! [ -x "$(command -v git)" ]; then
    apt update
    apt install -y git
  fi
}

# git pull ss
function check_scripts(){
  if [ ! -d "/home/config-ss" ]; then
    cd /home
    git clone https://github.com/Zerobxx/config-ss
  else
    cd /home/config-ss
    git pull
  fi
}

pre_install() {
    config_ssh
    check_git
    #check_scripts
}

pre_install    
bash /home/config-ss/deploy.sh
bash /home/config-ss/optimize.sh
