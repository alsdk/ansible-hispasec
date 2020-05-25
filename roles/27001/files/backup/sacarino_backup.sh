#!/bin/bash

HOST="sacarino"
SERVER="/home/backuo/"$HOST
# Ficheros de configuracion del servidor

rsync -av /etc $SERVER
rsync -av /home/develop $SERVER/home
rsync -av /home/inteco $SERVER/home

chown backuo.backuo /home/backuo/ -Rf
