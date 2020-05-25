#!/bin/sh

HOSTNAME=$1
IP=$2
SSH_CONFIG_ROOT="/tmp/$HOSTNAME-sshconfig-root.tmp"
SSH_CONFIG="/tmp/$HOSTNAME-sshconfig.tmp"

add_to_hosts() {
    if [ $(grep $HOSTNAME /etc/hosts|wc -l) -eq 0 ]
    then
        sudo sh -c 'echo "$HOSTNAME              $IP" >> /etc/hosts'
    fi
}

add_to_ssh_config_root() {
	echo "Host a$HOSTNAME"  >> $SSH_CONFIG_ROOT
	echo "    User root" >> $SSH_CONFIG_ROOT
	echo "    HostName $HOSTNAME"  >> $SSH_CONFIG_ROOT
	echo "    IdentityFile ~/.ssh/id_rsa_hispansible" >> $SSH_CONFIG_ROOT
}

add_to_ssh_config() {
	echo "Host $HOSTNAME"  >> $SSH_CONFIG
	echo "    User msalinas" >> $SSH_CONFIG
	echo "    HostName $HOSTNAME"  >> $SSH_CONFIG
	echo "    IdentityFile ~/.ssh/id_rsa_hispasec" >> $SSH_CONFIG
}

copyid_root() {
	ssh-copy-id -i ~/.ssh/id_rsa_hispansible.pub root@a$HOSTNAME
}

copyid() {
	ssh-copy-id -i ~/.ssh/id_rsa_hispasec.pub msalinas@$HOSTNAME
}

create_ansible() {
  mkdir -p /home/msalinas/ansible/envs/$ENV/host_vars/$HOSTNAME
  touch /home/msalinas/ansible/envs/$ENV/host_vars/$HOSTNAME/vars.yml
  ansible-vault create /home/msalinas/ansible/envs/$ENV/host_vars/$HOSTNAME/vault.yml
}

usage() {
	echo "./createnewhost.sh <hostname> <IP>"
}

if [ "$#" -eq 0 -o "$1" = "-h" -o "$1" = "--help" ]; then
	usage
	exit 0
fi

#add_to_hosts
add_to_ssh_config_root
add_to_ssh_config
copyid_root
copyid
exit 0
