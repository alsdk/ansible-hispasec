#!/usr/bin/env bash

PRIVATE=192.168.0.0/16

INTERNET_INTERFACE=`route | grep '^default' | grep -o '[^ ]*$'`;
PRIVATE_NETWORK_IP="$(cut -d'/' -f1 <<<${PRIVATE})";
PRIVATE_INTERFACE=`route | grep "^$PRIVATE_NETWORK_IP" | grep -o '[^ ]*$'`

# Loopback address
LOOP=127.0.0.1

# Delete old iptables rules
# and temporarily block all traffic.
iptables -P OUTPUT ACCEPT
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -F
iptables -t nat -F

# Allow local loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Prevent external packets from using loopback addr
iptables -A INPUT -i "$INTERNET_INTERFACE" -s "$LOOP" -j DROP
iptables -A FORWARD -i "$INTERNET_INTERFACE" -s "$LOOP" -j DROP
iptables -A INPUT -i "$INTERNET_INTERFACE" -d "$LOOP" -j DROP
iptables -A FORWARD -i "$INTERNET_INTERFACE" -d "$LOOP" -j DROP

# Anything coming from the Internet should have a real Internet address
iptables -A FORWARD -i "$INTERNET_INTERFACE" -s 192.168.0.0/16 -j DROP
iptables -A FORWARD -i "$INTERNET_INTERFACE" -s 172.16.0.0/12 -j DROP
iptables -A FORWARD -i "$INTERNET_INTERFACE" -s 10.0.0.0/8 -j DROP
iptables -A INPUT -i "$INTERNET_INTERFACE" -s 192.168.0.0/16 -j DROP
iptables -A INPUT -i "$INTERNET_INTERFACE" -s 172.16.0.0/12 -j DROP
iptables -A INPUT -i "$INTERNET_INTERFACE" -s 10.0.0.0/8 -j DROP

# Make sure NEW incoming tcp connections are SYN packets; otherwise we drop them
iptables -A INPUT -p tcp ! --syn -m conntrack --ctstate NEW -j DROP;

# Drop all NULL packets
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP;

# Check source address validity on packets going out to internet
#iptables -A FORWARD -s ! $PRIVATE -i tun0 -j DROP

# Block incoming pings (can be disabled)
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# Keep state of connections from local machine and private subnets
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED -o "$INTERNET_INTERFACE" -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate NEW -o "$INTERNET_INTERFACE" -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Masquerade local subnet
iptables -t nat -A POSTROUTING -s "$PRIVATE" -o "$INTERNET_INTERFACE" -j MASQUERADE

# Allow services such as www and ssh (can be disabled)
#iptables -A INPUT -p tcp --dport http -j ACCEPT
iptables -A INPUT -p tcp --dport ssh -j ACCEPT


# Allow packets from private subnets
iptables -A INPUT -i "$PRIVATE_INTERFACE" -j ACCEPT
iptables -A FORWARD -i "$PRIVATE_INTERFACE" -j ACCEPT

# Allow packets from TUN/TAP devices.
# When OpenVPN is run in a secure mode,
# it will authenticate packets prior
# to their arriving on a tun or tap
# interface.  Therefore, it is not
# necessary to add any filters here,
# unless you want to restrict the
# type of packets which can flow over
# the tunnel.
iptables -A INPUT -i tun+ -j ACCEPT
iptables -A FORWARD -i tun+ -j ACCEPT
iptables -A INPUT -i tap+ -j ACCEPT
iptables -A FORWARD -i tap+ -j ACCEPT


