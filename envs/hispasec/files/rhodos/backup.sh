#!/bin/bash

HOST="rhodos"
SERVER="/home/backuo/"$HOST

# Ficheros de configuracion del servidor

rsync -av /etc $SERVER/

chown backuo.backuo /home/backuo/ -Rf
