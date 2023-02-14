# MARBEL MQTT Examples

This repository contains a set of files acting as an example for spinning up an
MQTT server as well as an example python client using certificate based
authentification.

## Generating certificates

The tool `easyrsa` is used for generating a PKI, a CA and a client certificate.
On a debian based system run the following commands to set all up:

```bash
apt update
apt install easy-rsa

bash setup-certificates.sh
```

## Running the Demo

```bash
docker-compose up --build
```
