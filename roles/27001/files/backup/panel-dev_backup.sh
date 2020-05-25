#!/bin/bash

HOST=panel-dev
SERVER="/home/backuo/panel-dev"

mkdir -p $SERVER/etc
rsync -av /etc $SERVER/

chown backuo.backuo /home/backuo/panel-dev -Rf
