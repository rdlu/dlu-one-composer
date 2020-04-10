#! /bin/bash
SERVER="${1:-lan}"
CORPORATION=DluOneComposer
GROUP=DluOneComposer
CITY=City
STATE=State
COUNTRY=BR

if [ ! -f cert_auth_password ]; then
  echo "Generating a password for CA..."
  CERT_AUTH_PASS=`openssl rand -base64 32`
  echo $CERT_AUTH_PASS > cert_auth_password
fi
CERT_AUTH_PASS=`cat cert_auth_password`

if [ ! -f ca-cert.key ]; then
  echo "Creating a new certificate authority for $SERVER..."
  openssl \
    req \
    -subj "/CN=$SERVER.ca/OU=$GROUP/O=$CORPORATION/L=$CITY/ST=$STATE/C=$COUNTRY" \
    -new \
    -x509 \
    -passout pass:$CERT_AUTH_PASS \
    -keyout ca-cert.key \
    -out ca-cert.crt \
    -days 1825
fi

echo "Creating a client private key (used to decrypt the cert we get from the CA)"
openssl genrsa -out $SERVER.key

echo "Creating the CSR (Certitificate Signing Request) for $SERVER"
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
  -days 365

# sign the certificate with the certificate authority
openssl \
  x509 \
  -req \
  -days 365 \
  -in $SERVER.csr \
  -CA ca-cert.crt \
  -CAkey ca-cert.key \
  -CAcreateserial \
  -out $SERVER.crt \
  -extfile <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS.1:$SERVER,DNS.2:*.ssl.$SERVER,DNS.3:*.$SERVER")) \
  -extensions SAN \
  -passin pass:$CERT_AUTH_PASS


cat << EOF

>--------------------------------------------------------------------<
REMEMBER: Add the CA certificate to your target operating systems:

# ArchLinux / Manjaro

 sudo trust anchor --store ca-cert.crt

# MacOS X

 sudo security -v add-trusted-cert -r trustAsRoot -e hostnameMismatch -d -k /Library/Keychains/System.keychain "./ca-cert.crt"
EOF

# Mac OpenSSL config
#cat /System/Library/OpenSSL/openssl.cnf

cp -f ../configs/traefik/certificates.toml.default ../configs/traefik/certificates.toml
sed -i "s/localhost/$SERVER/g" ../configs/traefik/certificates.toml