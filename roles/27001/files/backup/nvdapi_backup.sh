#!/bin/bash

HOST=nvdapi
SERVER="/home/backuo/nvdapi"

mkdir -p $SERVER/etc
rsync -av /etc $SERVER/

chown backuo.backuo /home/backuo/nvdapi -Rf
