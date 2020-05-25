if [ -e /home/syncro/sync.lock ]
then
  echo "Rsync job already running...exiting"
  exit
fi

touch /home/syncro/sync.lock

. ~/.keychain/{{ ansible_hostname }}-sh && rsync -av -e "ssh -T -c arcfour -o Compression=no -x" syncro@{{ ansible_hostname | regex_replace('-2$', '') }}.koodous.com:/home/develop/almacen/ /home/develop/almacen/

#delete lock file at end of your job

rm /home/syncro/sync.lock
