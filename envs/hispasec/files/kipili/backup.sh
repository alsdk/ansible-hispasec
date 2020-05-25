#!/bin/bash

HOST="kipili"
SERVER="/home/backuo/kipili"

rsync -av /home/develop $SERVER # Por ejemplo 

chown backuo.backuo /home/backuo/ -Rf

logger BCK - Backup del servidor $HOST
