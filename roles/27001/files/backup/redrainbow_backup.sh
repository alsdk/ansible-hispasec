#!/bin/bash
HOST="redrainbow"
BKFOLDER="/home/backuo/"$HOST

mkdir -p $BKFOLDER

rsync -av /etc $BKFOLDER/
rsync -av /home/svn_antifraude $BKFOLDER/
rsync -av /home/develop $BKFOLDER/
rsync -av /var/lib/svn $BKFOLDER/

chown backuo.backuo $BKFOLDER -Rf

logger BCK - Backup del servidor $HOST

