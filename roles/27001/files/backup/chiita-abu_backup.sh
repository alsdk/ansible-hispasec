#!/bin/bash

HOST=chiita-abu
SERVER="/home/backuo/chiita-abu"

mkdir -p $SERVER/etc
rsync -av /etc $SERVER/

chown backuo.backuo /home/backuo/chiita-abu -Rf
