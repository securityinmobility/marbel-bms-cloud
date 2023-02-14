#!/bin/bash

set -euxo pipefail

make-cadir certs
cd certs

CA_PASSWORD="$(openssl rand 32 | hexdump -e'4/4 "%08X"')"
MOSQUITTO_CERT_PASSWORD="$(openssl rand 32 | hexdump -e'4/4 "%08X"')"
USER_CERT_PASSWORD="$(openssl rand 32 | hexdump -e'4/4 "%08X"')"

printf "$CA_PASSWORD" > ca_passfile

./easyrsa init-pki
printf "$CA_PASSWORD\n$CA_PASSWORD\nMARBEL Example CA\n" | ./easyrsa build-ca
./easyrsa "--passout=pass:$MOSQUITTO_CERT_PASSWORD" "--passin=file:ca_passfile" build-client-full mqtt-broker
./easyrsa "--passout=pass:$USER_CERT_PASSWORD" "--passin=file:ca_passfile" build-client-full python-example

cp pki/ca.crt ../mosquitto/ca.pem
cp pki/issued/mqtt-broker.crt ../mosquitto/cert.pem
openssl pkey -in pki/private/mqtt-broker.key -out ../mosquitto/key.pem --passin "pass:$MOSQUITTO_CERT_PASSWORD"

cp pki/ca.crt ../python-demo-client/ca.pem
cp pki/issued/python-example.crt ../python-demo-client/cert.pem
openssl pkey -in pki/private/python-example.key -out ../python-demo-client/key.pem --passin "pass:$USER_CERT_PASSWORD"
