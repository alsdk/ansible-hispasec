#!/bin/bash
HOST='omicron'
BACKUP_FOLDER='/home/backuo'

mkdir -p $BACKUP_FOLDER/$HOST/develop
rsync -av /home/develop $BACKUP_FOLDER/$HOST/develop
mkdir -p $BACKUP_FOLDER/$HOST/etc
rsync -av /etc $BACKUP_FOLDER/$HOST/etc

chown backuo:backuo $BACKUP_FOLDER/$HOST/ -Rf
