#!/bin/bash

SERVER="/home/backuo/sana"

mkdir -p $SERVER

rsync -av /home/develop $SERVER/
rsync -av /etc $SERVER/

chown -R backuo:backuo $SERVER
