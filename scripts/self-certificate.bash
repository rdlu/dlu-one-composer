#! /bin/bash

openssl req \
    -newkey rsa:2048 \
    -x509 \
    -nodes \
    -keyout server.key \
    -new \
    -out server.crt \
    -subj /CN=localhost \
    -reqexts SAN \
    -extensions SAN \
    -config <(cat /System/Library/OpenSSL/openssl.cnf \
        <(printf '[SAN]\nsubjectAltName=DNS:localhost,DNS:*.localhost')) \
    -sha256 \
    -days 3650


# Mac Add Cert
# sudo security -v add-trusted-cert -r trustAsRoot -e hostnameMismatch -d -k /Library/Keychains/System.keychain "./server.crt"