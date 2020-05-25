#!/bin/sh

# A Sample OpenVPN-aware firewall.

# eth0 is connected to the internet.
# tun0 is connected to a private subnet.

# para que funcione ssh por la iface publica
# con el tunel vpn levantado. En el cliente VPN, poner:
# ip rule add from x.x.x.x table 128
# ip route add table 128 to y.y.y.y/y dev ethX
# ip route add table 128 default via z.z.z.z
# x.x.x.x es la ip publica que tiene la iface de red.
# y.y.y.y/y es la subnet de la ip publica
# z.z.z.z es el gw por defecto
# ip rule add from 144.76.238.133 table 128
# ip route add table 128 to 144.76.238.0/27
# ip route add table 128 default via 144.76.238.129


# Change this subnet to correspond to your private
# ethernet subnet.  Home will use HOME_NET/24 and
# Office will use OFFICE_NET/24.
PRIVATE=10.8.0.0/24

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

# Check source address validity on packets going out to internet
#iptables -A FORWARD -s ! $PRIVATE -i tun0 -j DROP

# Block incoming pings (can be disabled)
#iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# Keep state of connections from local machine and private subnets
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED -o eth0 -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate NEW -o eth0 -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Masquerade local subnet
iptables -t nat -A POSTROUTING -s $PRIVATE -o eth0 -j MASQUERADE

# Allow services such as www and ssh (can be disabled)
iptables -A INPUT -p tcp --dport http -j ACCEPT
iptables -A INPUT -p tcp --dport https -j ACCEPT
iptables -A INPUT -p tcp --dport ssh -j ACCEPT

# Accept external connection from NEMESYS partners to connect to the WAPI honeyclient's interface
#iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
#iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Accept connections from koodous-mon (nagios)
iptables -A INPUT -p tcp --dport 5666 -j ACCEPT
iptables -A INPUT -p tcp --dport 8090 -j ACCEPT

# Accept the connections coming from WM API (port 27017) to catch analyses from MongoDB
#iptables -A INPUT -s 213.239.200.143 -p tcp --dport 27017 -j ACCEPT

## begin koodous-nginx rules ##
# internal VPN ports
iptables -A INPUT -p udp --dport 30060 -j ACCEPT
iptables -A INPUT -p tcp --dport 30060 -j ACCEPT
## end koodous-nginx rules ## 

## begin analyzers rules ##
# Allow incoming connections to 8090 from krat and koodous-nginx
iptables -A INPUT -p tcp -s 188.166.34.27 --dport 8090 -j ACCEPT
iptables -A INPUT -p tcp -s 138.201.35.73 --dport 8090 -j ACCEPT
## end analyzers rules ##

## begin krat rules ##
# Open incoming connections to port 10000 from analyzers and koodous-nginx
# Pusha
iptables -A INPUT -s 178.63.67.19 -p tcp --dport 10000 -j ACCEPT
# Razor
iptables -A INPUT -s 148.251.244.171 -p tcp --dport 10000 -j ACCEPT
# Furzu
iptables -A INPUT -s 78.46.49.148 -p tcp --dport 10000 -j ACCEPT
# Galat
iptables -A INPUT -s 136.243.39.26 -p tcp --dport 10000 -j ACCEPT
# Gurut
iptables -A INPUT -s 78.46.48.230 -p tcp --dport 10000 -j ACCEPT
# Gurgal
iptables -A INPUT -s 178.63.94.158 -p tcp -m tcp --dport 10000 -j ACCEPT
# Koodous-nginx
iptables -A INPUT -s 138.201.35.73 -p tcp -m tcp --dport 10000 -j ACCEPT
# Open incoming connections to port 9090 from koodous-nginx
iptables -A INPUT -s 138.201.35.73 -p tcp -m tcp --dport 9090 -j ACCEPT
## end krat rules ##

## begin avk1 rules ##
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
## end avk1 rules ##

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

# Allow packets from private subnets
#iptables -A INPUT -i eth1 -j ACCEPT
#iptables -A FORWARD -i eth1 -j ACCEPT


