#!/bin/bash

BKFOLDER="/home/backuo/udyat"

mkdir -p $BKFOLDER
rsync -av /etc $BKFOLDER/
rsync -av /home/develop $BKFOLDER/

chown -R backuo:backuo /home/backuo/udyat
