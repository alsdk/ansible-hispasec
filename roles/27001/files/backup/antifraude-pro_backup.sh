#!/bin/bash

HOST=antifraude-pro
SERVER="/home/backuo/antifraude-pro"

mkdir -p $SERVER/etc
rsync -av /etc $SERVER/

chown backuo.backuo /home/backuo/antifraude-pro -Rf
