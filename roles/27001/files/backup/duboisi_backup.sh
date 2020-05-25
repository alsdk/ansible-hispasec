#!/bin/bash
HOST="Duboisi"
SERVER="/home/backuo/duboisi"

# El respaldo de bases de dato se hace desde el usuario backuo.
rsync -av /home/asanchez/smobi/ $SERVER/smobi --exclude 'logs/'
rsync -av /home/asanchez/smaug/ $SERVER/smaug --exclude 'logs/'
rsync -av /etc/ $SERVER/etc

chown backuo.backuo /home/backuo/ -Rf
logger BCK - Backup del servidor $HOST

