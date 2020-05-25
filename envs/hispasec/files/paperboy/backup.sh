#!/bin/bash

HOST="paperboy"
SERVER="/home/backuo/paperboy"

mkdir -p $SERVER/etc
rsync -av /etc $SERVER/etc
mkdir -p $SERVER/develop 
rsync -av /home/develop/ $SERVER/develop
mkdir -p $SERVER/fw
rsync -av /root/fw.sh $SERVER/fw


chown backuo.backuo /home/backuo/paperboy -Rf
