#!/bin/bash

HOST="lisbeth"
BKFOLDER="/home/backuo/"$HOST

# Ficheros de configuracion del servidor
mkdir -p $BKFOLDER
mkdir -p $BKFOLDER/jrascon
rsync -av /etc $BKFOLDER/
rsync -av /home/jrascon/bin $BKFOLDER/jrascon/
rsync -av /home/jrascon/lida $BKFOLDER/jrascon/ --exclude old_cuckoo/storage/binaries --exclude logs --exclude cuckoo/storage/binaries
rsync -av /home/jrascon/radium $BKFOLDER/jrascon/
rsync -av /var/www $BKFOLDER/

chown backuo.backuo /home/backuo/ -Rf
