#!/bin/sh

IFACE=$(ip a|grep "^.:"|grep -v 'lo:'| grep -v 'tun'|awk -F: '{print $2}'|awk '$1=$1;q')
PUBLIC_IP=$(ip addr show dev $IFACE|grep 'inet '|awk '{print $2}'|sed -e 's_\/.[[:digit:]]__g')
SUBNET=$(ip addr show dev $IFACE|grep 'inet '|awk '{print $2}' |awk -F'.' '{print $4}'|sed -e 's_^.*/_0/_g')
SUBNET2=$(ip addr show dev $IFACE|grep 'inet '|awk '{print $2}' |awk -F'.' '{print $1 "." $2 "." $3 "."}')
SUCH_SUBNET=${SUBNET2}${SUBNET}
GATEWAY=$(ip r|head|grep default| awk '{print $3}')

#echo $IFACE
#echo $PUBLIC_IP
##echo $SUBNET
##echo $SUBNET2
#echo $SUCH_SUBNET
#echo $GATEWAY

ip rule add from $PUBLIC_IP table 128 2>/dev/null
ip route add table 128 to $SUCH_SUBNET dev $IFACE 2>/dev/null
ip route add table 128 default via $GATEWAY 2>/dev/null

exit 0
