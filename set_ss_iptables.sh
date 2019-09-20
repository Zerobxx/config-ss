#!/bin/bash
#

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin;
export PATH


# clear needless rules
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F
iptables -X
iptables -Z
iptables -F -t nat
iptables -X -t nat
iptables -Z -t nat
iptables -F -t mangle
iptables -X -t mangle
iptables -Z -t mangle


# INPUT chain rules
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 5678 -j ACCEPT
#iptables -A INPUT -p udp --dport 5678 -j ACCEPT
iptables -A INPUT -p tcp --dport 1234 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT


#set chain default rules
iptables -P INPUT DROP
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
