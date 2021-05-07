# passhport configuration file. You should copy it to 
# /etc/passhport/passhport.ini if you want to do modifications
[SSL]
SSL            = ${PASSHPORTD_SSL}
SSL_CERTIFICAT = /etc/passhport/certs/cert.pem


[Network]
# Passhportd hostname should always be localhost since both 
# passhport and passhportd should work on the same server
PASSHPORTD_HOSTNAME = ${PASSHPORTD_HOSTNAME}
PORT = ${PASSHPORTD_PORT}


[Environment]
# Logs
SCRIPT_LOGS_PATH = /var/log/passhport
SSH_SCRIPT       = /passhport/passhport/passhport-connect.sh


[MISC]
# Allow to directly up/download file to a server behind a target via scp
# Activate this can be dangerous (PaSSHport do a rm -rf on targets)
SCP_THROUGH_TARGET = False
# Targets identifiants are the same for every user
UNIQ_TARGETS_ID = True
# Relaunch passhport once a session is over
KEEPCONNECT = True
# Node name when working in HA
NODE_NAME = ${PASSHPORTD_NODE_NAME}
