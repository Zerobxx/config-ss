#!/bin/bash
#

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin;
export PATH


install_ss() {

    if ! [ -x "$(command -v ss-server)" ]; then
    
        apt-get install software-properties-common -y
        add-apt-repository ppa:max-c-lv/shadowsocks-libev -y
        apt-get update
        apt install shadowsocks-libev -y
        
    fi
    
    if [ ! -d "/etc/shadowsocks-libev" ];then
      mkdir /etc/shadowsocks-libev
    else
      mv /etc/shadowsocks-libev/* /tmp
    fi
    
    cd /home/config-ss
    source ss.pass
    
    #cp /home/config-ss/config/ss-server/*  /etc/shadowsocks-libev
    cat > /etc/shadowsocks-libev/config.json << EOF
{
    "server":"0.0.0.0",
    "server_port":5678,
    "local_port":1080,
    "password":"${PASSWORD}",
    "timeout":120,
    "method":"chacha20-ietf-poly1305"
}
EOF
}


install_supervisor() {

    if ! [ -x "$(command -v supervisorctl)" ]; then
        apt update
        apt install supervisor -y
    fi
    
    if [ ! -f "/etc/supervisor/conf.d/ss.conf" ]; then
        cp /home/config-ss/config/supervisor/ss.conf /etc/supervisor/conf.d/ss.conf
    fi
}


configure_ss_server() {

    #cp /home/config-ss/config/shadowsocks-libev /etc/default/shadowsocks-libev
    #adduser --system --disabled-password --disabled-login --no-create-home shadowsocks
    cp /home/config-ss/config/local.conf /etc/sysctl.d/local.conf
    sysctl --system
    
}

config_iptables() {

    
    #restore
    #iptables-restore < /etc/iptables/rules.v4
    cd /home/config-ss
    bash set_ss_iptables.sh
    
    if [ ! -d "/etc/iptables" ]; then
        mkdir -p /etc/iptables
    fi
    
    #save
    iptables-save > /etc/iptables/rules.v4
}


install() {

    install_ss
    install_supervisor
    configure_ss_server
    config_iptables
   
}

install
