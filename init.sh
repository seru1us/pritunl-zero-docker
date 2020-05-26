#!/bin/bash

sudo pritunl-ssh-host config add-token $HOST_TOKEN
sudo pritunl-ssh-host config hostname $BASTION_HOSTNAME
sudo pritunl-ssh-host config server $PZ_HOST

sudo useradd bastion
chmod 0600 /ssh/ssh_host_rsa_key
sudo sed -i '/^TrustedUserCAKeys/d' /etc/ssh/sshd_config
sudo sed -i '/^AuthorizedPrincipalsFile/d' /etc/ssh/sshd_config

tee /ssh/sshd_config << EOF

Match User bastion
    AllowAgentForwarding no
    AllowTcpForwarding yes
    PermitOpen *.$PZ_HOST:22
    GatewayPorts no
    X11Forwarding no
    PermitTunnel yes
    ForceCommand echo 'Pritunl Zero Bastion Host'
    TrustedUserCAKeys /etc/ssh/trusted
    AuthorizedPrincipalsFile /etc/ssh/principals
Match all

EOF
sudo tee /etc/ssh/principals << EOF
bastion
EOF

TRUSTED_PUBKEY=$(curl $TP_URL)

sudo tee /etc/ssh/trusted << EOF
ssh-rsa $TRUSTED_PUBKEY
EOF

/usr/sbin/sshd -D -f /ssh/sshd_config
