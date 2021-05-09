# Copyright (c) 2021 FEROX YT EIRL, www.ferox.yt <devops@ferox.yt>
# Copyright (c) 2021 Jérémy WALTHER <jeremy.walther@golflima.net>
# See <https://github.com/frxyt/docker-passhport> for details.

ARG ALPINE_VERSION=alpine:3.13
FROM ${ALPINE_VERSION}
LABEL maintainer="Jérémy WALTHER <jeremy@ferox.yt>"

# Install required packages and create passhport user
RUN set -ex; \
    apk add --no-cache \
        bash \
        curl \
        gettext \
        openssl \
        openssh-server \
        perl \
        python3 \
        supervisor \
        tzdata \
        wget; \
    rm -f /etc/ssh/sshd_config; \
    adduser -Dh /home/passhport -s /bin/bash passhport; \
    mkdir -p /etc/passhport/certs /var/lib/passhport /var/log/passhport; \
    chown passhport:passhport -R /var/lib/passhport /var/log/passhport;

# Download PaSSHport
ARG PASSHPORT_VERSION=2.5
RUN set -ex; \
    apk add --no-cache git; \
    git clone http://github.com/LibrIT/passhport.git /home/passhport/passhport; \
    cd /home/passhport/passhport; \
    [[ -n "${PASSHPORT_VERSION}" ]] && git checkout ${PASSHPORT_VERSION}; \
    rm -rf .git*; \
    apk del git; \
    ln -s /home/passhport/passhport/tools/passhportd.sh /usr/local/bin/passhportd; \
    ln -s /home/passhport/passhport/tools/passhport-admin.sh /usr/local/bin/passhport-admin;

# Install required PaSSHport dependancies
RUN set -ex; \
    cd  /home/passhport/passhport; \
    apk add --no-cache \
        python3-dev \
        py3-pip; \
    pip3 install virtualenv; \
    su -c 'virtualenv -p python3 ~/passhport-run-env' passhport; \
    apk add --no-cache \
        gcc \
        libc-dev \
        libffi-dev \
        openssl-dev; \
    su -c '~/passhport-run-env/bin/pip install -r requirements.txt' passhport; \
    apk del \
        gcc \
        libc-dev \
        libffi-dev \
        python3-dev \
        py3-pip \
        openssl-dev;

COPY bin/entrypoint                 /usr/local/bin/frx-entrypoint
COPY bin/healthcheck                /usr/local/bin/frx-healthcheck
COPY bin/log                        /usr/local/bin/frx-log
COPY bin/start                      /usr/local/bin/frx-start
COPY etc/${PASSHPORT_VERSION}/*     /etc/passhport/
COPY etc/sshd_config.tpl            /etc/ssh/
COPY etc/supervisord.conf           /etc/supervisord.conf

ARG SOURCE_BRANCH=master
ARG SOURCE_COMMIT=HEAD
RUN set -ex; \
    echo "[frxyt/passhport:${PASSHPORT_VERSION}-${SOURCE_BRANCH}] <https://github.com/frxyt/docker-passhport>" > /etc/frx_version; \
    echo "[version: ${SOURCE_BRANCH}@${SOURCE_COMMIT}]" >> /etc/frx_version

ENV FRX_DEBUG=0 \
    FRX_LOG_PREFIX_MAXLEN=10 \
    PASSHPORT_CERT_DAYS=365 \
    PASSHPORT_CERT_SUBJ='/C=FX/ST=None/L=None/O=None/OU=None/CN=localhost' \
    PASSHPORTD_DB_SALT=thepasshportsafeandsecuresalt \
    PASSHPORTD_DB_SESSIONS_TO=12 \
    PASSHPORTD_HOSTNAME=localhost \
    PASSHPORTD_KEEPCONNECT=True \
    PASSHPORTD_LISTENING_IP=0.0.0.0 \
    PASSHPORTD_MAXLOGSIZE=5 \
    PASSHPORTD_NODE_NAME=passhport-node \
    PASSHPORTD_NOFIT_FROM=passhport@bastion \
    PASSHPORTD_NOTIF_LOG_TYPE=email \
    PASSHPORTD_NOTIF_SMTP=127.0.0.1 \
    PASSHPORTD_NOTIF_TO='root, admin@passhport' \
    PASSHPORTD_PORT=5000 \
    PASSHPORTD_SCP_THROUGH_TARGET=False \
    PASSHPORTD_SSL=True \
    PASSHPORTD_UNIQ_TARGETS_ID=True \
    SSHD_LISTEN_ADDRESS=0.0.0.0 \
    SSHD_PASSWD_AUTH=no \
    SSHD_PORT=22 \
    SSHD_PUBKEY_AUTH=yes \
    TZ=Etc/UTC

COPY Dockerfile     /home/passhport/
COPY LICENSE        /home/passhport/
COPY README.md      /home/passhport/

WORKDIR /home/passhport
EXPOSE 22 5000
HEALTHCHECK --interval=15s --timeout=5s --start-period=1m --retries=3 CMD ["/usr/local/bin/frx-healthcheck"]
ENTRYPOINT ["/usr/local/bin/frx-entrypoint"]
CMD ["/usr/local/bin/frx-start"]