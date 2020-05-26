#!/bin/bash

pritunl-ssh-host config add-token $HOST_TOKEN
pritunl-ssh-host config hostname $BASTION_HOSTNAME
pritunl-ssh-host config server $PZ_HOST

useradd bastion
sed -i '/^TrustedUserCAKeys/d' /etc/ssh/sshd_config
sed -i '/^AuthorizedPrincipalsFile/d' /etc/ssh/sshd_config

tee /etc/ssh/sshd_config << EOF

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
tee /etc/ssh/principals << EOF
bastion
EOF

TRUSTED_PUBKEY=$(curl $TP_URL)

tee /etc/ssh/trusted << EOF
ssh-rsa $TRUSTED_PUBKEY
EOF

/usr/sbin/sshd -D -f /ssh/sshd_config
