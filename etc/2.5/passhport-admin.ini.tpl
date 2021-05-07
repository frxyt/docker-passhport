# passhport-admin configuration file. You should copy it to 
# /etc/passhport/passhport-admin.ini if you want to do modifications
[SSL]
SSL            = ${PASSHPORTD_SSL}
SSL_CERTIFICAT = /etc/passhport/certs/cert.pem

[Network]
PASSHPORTD_HOSTNAME = ${PASSHPORTD_HOSTNAME}
PASSHPORTD_PORT = ${PASSHPORTD_PORT}
