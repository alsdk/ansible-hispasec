#!/bin/sh

# ssh packets gets routed via the vpn not eth0...
ip rule add table 128 from 148.251.244.171
ip route add table 128 to 148.251.244.0/27 dev eth0
ip route add table 128 default via 148.251.244.161
