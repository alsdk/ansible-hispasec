#!/bin/sh

# Delete old iptables rules
# and temporarily block all traffic.
iptables -P OUTPUT DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -F
iptables -t nat -F

# Set default policies
iptables -P OUTPUT ACCEPT
iptables -P INPUT DROP
iptables -P FORWARD DROP

#Accept local connections
iptables -A INPUT -i lo -j ACCEPT;
iptables -A OUTPUT -o lo -j ACCEPT;

# Prevent external packets from using loopback addr
iptables -A INPUT -i eth0 -s $LOOP -j DROP
iptables -A FORWARD -i eth0 -s $LOOP -j DROP
iptables -A INPUT -i eth0 -d $LOOP -j DROP
iptables -A FORWARD -i eth0 -d $LOOP -j DROP

# Anything coming from the Internet should have a real Internet address
iptables -A FORWARD -i eth0 -s 192.168.0.0/16 -j DROP
iptables -A FORWARD -i eth0 -s 172.16.0.0/12 -j DROP
iptables -A FORWARD -i eth0 -s 10.0.0.0/8 -j DROP
iptables -A INPUT -i eth0 -s 192.168.0.0/16 -j DROP
iptables -A INPUT -i eth0 -s 172.16.0.0/12 -j DROP
iptables -A INPUT -i eth0 -s 10.0.0.0/8 -j DROP

# Make sure NEW incoming tcp connections are SYN packets; otherwise we drop them
iptables -A INPUT -p tcp ! --syn -m conntrack --ctstate NEW -j DROP;

# Drop all NULL packets
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP;

# Block incoming pings (can be disabled)
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# Keep state of connections from local machine and private subnets
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED -o eth0 -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate NEW -o eth0 -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Accept the connections coming from the port ssh (22) from all
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Accept external connection from NEMESYS partners to connect to the WAPI honeyclient's interface
#iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
#iptables -A INPUT -p tcp --dport 22 -j ACCEPT

#Accept the connections from jenkins (213.239.194.5)
iptables -A INPUT -p tcp -s 213.239.194.5 --dport 22 -j ACCEPT

# Accept connections from monitor.koodous.com
iptables -A INPUT -p tcp -s 144.76.7.117 --dport 5666 -j ACCEPT
iptables -A INPUT -p tcp -s 144.76.7.117 --dport 8090 -j ACCEPT

# Accept the connections coming from nagios (port 5666) TODO.
#iptables -A INPUT -s 87.216.208.128 -p tcp --dport 5666 -j ACCEPT

# Accept the connections coming from WM API (port 27017) to catch analyses from MongoDB
#iptables -A INPUT -s 213.239.200.143 -p tcp --dport 27017 -j ACCEPT

# Open incoming connections to port 5400 from analyzers, koodous-nginx and krat
# Krat
iptables -A INPUT -p tcp -s 188.166.34.27 --dport 8090 -j ACCEPT
# Furzu
iptables -A INPUT -p tcp -s 78.46.49.148 --dport 5400 -j ACCEPT
# Gurut
iptables -A INPUT -p tcp -s 78.46.48.230 --dport 5400 -j ACCEPT
# Pusha
iptables -A INPUT -p tcp -s 178.63.67.19 --dport 5400 -j ACCEPT
# Galat
iptables -A INPUT -p tcp -s 136.243.39.26 --dport 5400 -j ACCEPT
# Razor
iptables -A INPUT -p tcp -s 148.251.244.171 --dport 5400 -j ACCEPT
# Gurgal
iptables -A INPUT -p tcp -s 178.63.94.158 --dport 5400 -j ACCEPT
# Koodous-nginx
iptables -A INPUT -s 138.201.35.73 -p tcp -m tcp --dport 5400 -j ACCEPT

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








