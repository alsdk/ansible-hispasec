#!/bin/bash

HOST="mendrugo"
BKFOLDER="/home/backuo/server/"$HOST

# Ficheros de configuracion del servidor
mkdir -p $BKFOLDER
rsync -av /etc $BKFOLDER/
rsync -av /home/ftp/mnt $BKFOLDER/ftp --exclude software
rsync -av /home/sistemas $BKFOLDER/
rsync -av /home/hispasec $BKFOLDER/ 
rsync -av /home/user-auditoria $BKFOLDER/
rsync -av /home/projects/inteco $BKFOLDER/
rsync -av /home/backuo $BKFOLDER/ --exclude offline_servers --exclude log --exclude laptop --exclude users.old --exclude server --exclude dbs.old --exclude data.old

chown backuo.backuo $BKFOLDER -Rf

