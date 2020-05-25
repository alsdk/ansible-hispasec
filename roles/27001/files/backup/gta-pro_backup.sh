#!/bin/bash

HOST=gta-pro
SERVER="/home/backuo/gta-pro"

mkdir -p $SERVER/etc
rsync -av /etc $SERVER/

chown backuo.backuo /home/backuo/gta-pro -Rf
