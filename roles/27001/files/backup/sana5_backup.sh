#!/bin/bash

HOST=sana5
SERVER="/home/backuo/sana5"

mkdir -p $SERVER/etc
rsync -av /etc $SERVER/

chown backuo.backuo /home/backuo/sana5 -Rf
