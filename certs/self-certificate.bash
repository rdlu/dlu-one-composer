#! /bin/bash
SERVER="${SERVER:-lan}"
CORPORATION=DluOneComposer
GROUP=DluOneComposer
CITY=City
STATE=State
COUNTRY=BR

# CERT_AUTH_PASS=`openssl rand -base64 32`
# echo $CERT_AUTH_PASS > cert_auth_password
CERT_AUTH_PASS=`cat cert_auth_password`

# create the certificate authority
# openssl \
#   req \
#   -subj "/CN=$SERVER.ca/OU=$GROUP/O=$CORPORATION/L=$CITY/ST=$STATE/C=$COUNTRY" \
#   -new \
#   -x509 \
#   -passout pass:$CERT_AUTH_PASS \
#   -keyout ca-cert.key \
#   -out ca-cert.crt \
#   -days 36500

# create client private key (used to decrypt the cert we get from the CA)
openssl genrsa -out $SERVER.key

# create the CSR(Certitificate Signing Request)
openssl \
  req \
  -new \
  -nodes \
  -subj "/CN=$SERVER/OU=$GROUP/O=$CORPORATION/L=$CITY/ST=$STATE/C=$COUNTRY" \
  -sha256 \
  -extensions v3_req \
  -reqexts SAN \
  -key $SERVER.key \
  -out $SERVER.csr \
  -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS.1:$SERVER,DNS.2:*.ssl.$SERVER.dev,DNS.3:*.$SERVER")) \
  -days 36500

# sign the certificate with the certificate authority
openssl \
  x509 \
  -req \
  -days 36500 \
  -in $SERVER.csr \
  -CA ca-cert.crt \
  -CAkey ca-cert.key \
  -CAcreateserial \
  -out $SERVER.crt \
  -extfile <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS.1:$SERVER,DNS.2:*.ssl.$SERVER,DNS.3:*.$SERVER")) \
  -extensions SAN \
  -passin pass:$CERT_AUTH_PASS

# sudo trust anchor --store ca-cert.crt



# Mac Add Cert
# sudo security -v add-trusted-cert -r trustAsRoot -e hostnameMismatch -d -k /Library/Keychains/System.keychain "./server.crt"

# Mac OpenSSL config
#cat /System/Library/OpenSSL/openssl.cnf