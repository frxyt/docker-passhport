[uwsgi]
chdir  = /home/passhport
virtualenv = passhport-run-env
file = /home/passhport/passhport/tools/passhportd.wsgi
uid = passhport
gid = passhport

master = true
processes = ${UWSGI_PROCESSES}
pidfile = /run/uwsgi/passhport.pid

shared-socket = ${PASSHPORTD_LISTENING_IP}:${PASSHPORTD_PORT}
https = =0,/etc/passhport/certs/cert.pem,/etc/passhport/certs/key.pem