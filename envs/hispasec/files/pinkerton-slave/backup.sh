#!/bin/bash

BKFOLDER="/home/backuo/pinkerton-slave"

# Ficheros de configuracion del servidor
mkdir -p $BKFOLDER
rsync -av /etc $BKFOLDER/

chown backuo: $BKFOLDER -Rf
