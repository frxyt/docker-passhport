# Passhportd configuration file. You should copy it to
# /etc/passhport/passhportd.ini if you want to do modifications
[SSL]
SSL            = ${PASSHPORTD_SSL}
SSL_CERTIFICAT = /etc/passhport/certs/cert.pem
SSL_KEY        = /etc/passhport/certs/key.pem


[Network]
LISTENING_IP   = ${PASSHPORTD_LISTENING_IP}
PORT = ${PASSHPORTD_PORT}


[Database]
SQLALCHEMY_TRACK_MODIFICATIONS = True
SQLALCHEMY_DATABASE_DIR        = /var/lib/passhport
SQLALCHEMY_MIGRATE_REPO        = /var/lib/passhport/db_repository
# For SQLite
SQLALCHEMY_DATABASE_URI        = sqlite:////var/lib/passhport/app.db
# Salt for encrypt passwords in database 
# (used only if password change is activated in passhport config)
SALT                           = "${PASSHPORTD_DB_SALT}"


[LDAP]
# LDAP is totally optionnal (used for proprietary Web UI and future purposes)
LDAP_PROVIDER_URL       = ldap.passhport.org
LDAP_PORT               = 389
LDAP_USER_BASEDN        = ou=people,dc=passhport,dc=org
LDAP_LOGIN_SEARCH_FIELD = mail
LDAP_ACC                = uid=passhport,ou=people,dc=passhport,dc=org
LDAP_PASS               = thepasshportaccountsecuredpassword


[Environment]
# SSH Keyfile path
SSH_KEY_FILE     = /home/passhport/.ssh/authorized_keys
# Python and passhport paths
PASSHPORT_PATH   = /home/passhport/passhport/passhport/passhport
PYTHON_PATH      = /home/passhport/passhport-run-env/bin/python3
#External access (optional - commercial use)
OPEN_ACCESS_PATH = /home/passhport/passhwall.sh

[NOTIFICATIONS]
NOTIF_LOG_TYPE  = ${PASSHPORTD_NOTIF_LOG_TYPE}
NOTIF_TO        = ${PASSHPORTD_NOTIF_TO}
NOFIT_FROM      = ${PASSHPORTD_NOTIF_FROM}
NOTIF_SMTP      = ${PASSHPORTD_NOTIF_SMTP}

[MISC]
# Maximum log file size in MB
MAXLOGSIZE = ${PASSHPORTD_MAXLOGSIZE}
# Node Name in case of HA
NODE_NAME = ${PASSHPORTD_NODE_NAME}
# Databases sessions default timeout in hours
DB_SESSIONS_TO = ${PASSHPORTD_DB_SESSIONS_TO}
