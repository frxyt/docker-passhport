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
        openssl \
        openssh-server \
        perl \
        python3 \
        supervisor; \
    adduser -Dh /home/passhport -s /bin/bash passhport; \
    mkdir -p /etc/passhport/certs /var/lib/passhport /var/log/passhport; \
    chown passhport:passhport -R /etc/passhport /var/lib/passhport /var/log/passhport;

# Download PaSSHport and copy configuration files
ARG PASSHPORT_VERSION=2.5
RUN set -ex; \
    apk add --no-cache git; \
    git clone http://github.com/LibrIT/passhport.git /passhport; \
    cd /passhport; \
    [[ -n "${PASSHPORT_VERSION}" ]] && git checkout ${PASSHPORT_VERSION}; \
    rm -rf .git; \
    apk del git; \
    sed -e 's,/home/passhport/certs/,/etc/passhport/certs/,g' \
        -e 's,/home/passhport/passhport/,/passhport/passhport/,g' \
        -i passhport/passhport.ini; \
    sed -e 's,/home/passhport/certs/,/etc/passhport/certs/,g' \
        -i passhport-admin/passhport-admin.ini; \
    sed -e 's,/home/passhport/certs/,/etc/passhport/certs/,g' \
        -e 's,/home/passhport/passhport/,/passhport/passhport/,g' \
        -e 's,/home/passhport/var,/var/lib/passhport,g' \
        -i passhportd/passhportd.ini; \
    cp passhport/passhport.ini /etc/passhport/; \
    cp passhport-admin/passhport-admin.ini /etc/passhport/; \
    cp passhportd/passhportd.ini /etc/passhport/; \
    sed -ie 's,/home/passhport/passhport/,/passhport/,g' tools/passhportd.sh; \
    sed -ie 's,/home/passhport/passhport/,/passhport/,g' tools/passhport-admin.sh; \
    ln -s /passhport/tools/passhportd.sh /usr/local/bin/passhportd; \
    ln -s /passhport/tools/passhport-admin.sh /usr/local/bin/passhport-admin;

# Install required PaSSHport dependancies
RUN set -ex; \
    cd  /passhport; \
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

COPY bin/entrypoint         /usr/local/bin/frx-entrypoint
COPY bin/log                /usr/local/bin/frx-log
COPY bin/start              /usr/local/bin/passhport-start
COPY etc/supervisord.conf   /etc/supervisor/supervisord.conf

ARG SOURCE_BRANCH=master
ARG SOURCE_COMMIT=HEAD
RUN set -ex; \
    echo "[frxyt/passhport:${PASSHPORT_VERSION}-${SOURCE_BRANCH}] <https://github.com/frxyt/docker-passhport>" > /etc/frx_version; \
    echo "[version: ${SOURCE_BRANCH}@${SOURCE_COMMIT}]" >> /etc/frx_version

ENV FRX_LOG_PREFIX_MAXLEN=10 \
    PASSHPORT_CERT_DAYS=3650 \
    PASSHPORT_CERT_SUBJ='/C=FX/ST=None/L=None/O=None/OU=None/CN=localhost' \
    PASSHPORTD_HOSTNAME=localhost
WORKDIR /home/passhport
EXPOSE 22 5000
HEALTHCHECK --interval=1m --timeout=5s --start-period=1m --retries=3 CMD curl -f --insecure https://127.0.0.1:5000 || exit 1
ENTRYPOINT ["/usr/local/bin/frx-entrypoint"]
CMD ["/usr/local/bin/passhport-start"]