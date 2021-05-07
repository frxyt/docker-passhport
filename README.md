# Docker Image for [PaSSHport](https://github.com/LibrIT/passhport), by [FEROX](https://ferox.yt)

![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/frxyt/passhport.svg)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/frxyt/passhport.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/frxyt/passhport.svg)
![GitHub issues](https://img.shields.io/github/issues/frxyt/docker-passhport.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/frxyt/docker-passhport.svg)

This image packages PaSSHport !

* Docker Hub: <https://hub.docker.com/r/frxyt/passhport>
* GitHub: <https://github.com/frxyt/docker-passhport>

## Docker Hub Image

**`frxyt/passhport`**

## Usage

### Test it locally

1. Clone the project: `git clone https://github.com/frxyt/docker-passhport.git`, then `cd docker-passhport`
1. Start it: `docker-compose up -d --build`
1. Read the admin doc: <https://docs.passhport.org/en/latest/getting-started.html>
1. Configure it: `docker-compose exec -u passhport passhport bash`
1. Connect to your servers: `ssh user@127.0.0.1 -p 22`

### Configurable environment variables

These environment variables can be overriden to change the default behavior of the image and adapt it to your needs:

| Name                            | Default value                   | Example                         | Description
| :------------------------------ | :------------------------------ | :------------------------------ | :----------
| `FRX_LOG_PREFIX_MAXLEN`         | `10`                            | `16`                            | Maximum length of prefix displayed in logs
| `PASSHPORT_CERT_DAYS`           | `365`                           | `3650`                          | PaSSHport certificate duration in days
| `PASSHPORT_CERT_SUBJ`           | `/C=FX/ST=None/L=None/O=None/OU=None/CN=localhost` | `/C=FR/ST=67/L=SXB/O=FRXYT/OU=IT/CN=xrdp.frx.yt` | PaSSHport certificate subject
| `PASSHPORTD_DB_SALT`            | `thepasshportsafeandsecuresalt` | `VerySecureSalt`                | PaSSHport database salt for password encryption
| `PASSHPORTD_DB_SESSIONS_TO`     | `12`                            | `10`                            | PaSSHport database sessions default timeout in hours
| `PASSHPORTD_HOSTNAME`           | `localhost`                     | `bastion.frx.yt`                | PaSSHport hostname
| `PASSHPORTD_KEEPCONNECT`        | `True`                          | `True` / `False`                | Relaunch PaSSHport once a session is over
| `PASSHPORTD_MAXLOGSIZE`         | `5`                             | `10`                            | PaSSHport maximum log file size in MB
| `PASSHPORTD_NODE_NAME`          | `passhport-node`                | `passhport`                     | Relaunch Node Name in case of HA
| `PASSHPORTD_NOFIT_FROM`         | `passhport@bastion`             | `passhport@bastion.frx.yt`      | E-mail address sending PaSSHport notifications
| `PASSHPORTD_NOTIF_LOG_TYPE`     | `email`                         | `email`                         | Only email
| `PASSHPORTD_NOTIF_SMTP`         | `127.0.0.1`                     | `smtp`                          | SMTP server for sending PaSSHport notifications
| `PASSHPORTD_NOTIF_TO`           | `root, admin@passhport`         | `it@frx.yt`                     | Recipients of PaSSHport notifications
| `PASSHPORTD_PORT`               | `5000`                          | `5000`                          | PaSSHport admin port
| `PASSHPORTD_SCP_THROUGH_TARGET` | `False`                         | `True` / `False`                | Allow to directly up/download file to a server behind a target via scp
| `PASSHPORTD_SSL`                | `True`                          | `True` / `False`                | Use SSL for PaSSHport
| `PASSHPORTD_UNIQ_TARGETS_ID`    | `True`                          | `True` / `False`                | Targets identifiants are the same for every user
| `SSHD_LISTEN_ADDRESS`           | `0.0.0.0`                       | `192.168.1.10`                  | SSHD listen address
| `SSHD_PASSWD_AUTH`              | `no`                            | `yes` / `no`                    | Enable password authentication in SSHD
| `SSHD_PORT`                     | `22`                            | `2200`                          | SSHD listen port
| `SSHD_PUBKEY_AUTH`              | `yes`                           | `yes` / `no`                    | Enable public key authentication in SSHD
| `TZ`                            | `Etc/UTC`                       | `Europe/Paris`                  | Container time zone

## Build & Test

```sh
docker build -f Dockerfile -t frxyt/passhport:latest .
docker run --rm -d --name  frxyt/passhport:latest
docker exec -itu passhport passhport bash
docker stop passhport
```

## License

This project and images are published under the [MIT License](LICENSE).

```
MIT License

Copyright (c) 2021 FEROX YT EIRL, www.ferox.yt <devops@ferox.yt>
Copyright (c) 2021 Jérémy WALTHER <jeremy.walther@golflima.net>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```