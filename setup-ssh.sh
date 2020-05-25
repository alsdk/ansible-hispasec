#!/bin/sh


if [ -z "$1" ]
then
    echo "usage: ./setup-ssh.sh <hostname>"
    exit
fi

HOST="$1"
SSH_CONFIG=/tmp/ssh.config

##### root login
# copy ssh cert
    ssh-copy-id -i ~/.ssh/id_rsa_hispansible root@$HOST
    # ansible/root account
    echo "Host a$HOST"  >> $SSH_CONFIG
    echo "    User root" >> $SSH_CONFIG
    echo "    HostName $HOST"  >> $SSH_CONFIG
    echo "    IdentityFile ~/.ssh/id_rsa_hispansible" >> $SSH_CONFIG
    # msalinas user account
    ssh-copy-id -i ~/.ssh/id_rsa_hispasec msalinas@a$HOST
    echo >> $SSH_CONFIG
    echo "Host $HOST"  >> $SSH_CONFIG
    echo "    User msalinas" >> $SSH_CONFIG
    echo "    HostName $HOST"  >> $SSH_CONFIG
    echo "    IdentityFile ~/.ssh/id_rsa_hispasec" >> $SSH_CONFIG

