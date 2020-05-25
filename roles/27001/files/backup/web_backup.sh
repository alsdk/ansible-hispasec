#!/bin/bash

HOST="web"
BKFOLDER="/home/backuo/"$HOST

mkdir -p $BKFOLDER

rsync -av /home/develop $BKFOLDER
rsync -av /etc $BKFOLDER

chown backuo.backuo /home/backuo/web -Rf
