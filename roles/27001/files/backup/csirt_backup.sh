#!/bin/bash

HOST="csirt"
SERVER="/home/backuo/"$HOST

# Ficheros de configuracion del servidor
mkdir -p $SERVER/etc
rsync -av /etc $SERVER/etc

chown backuo.backuo /home/backuo/ -Rf


