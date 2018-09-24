#!/bin/bash

CA_API_SERVER_URL=${CA_API_SERVER_URL:-$HOSTNAME}
CA_API_SERVER_PLAIN_PORT=${CA_API_SERVER_PLAIN_PORT:-8080}
CA_OSCP_SERVER_URL=${CA_OSCP_SERVER_URL:-$HOSTNAME}
CA_OSCP_SERVER_PORT=${CA_OSCP_SERVER_PORT:-2560}

ROOT_PASSPHRASE=${ROOT_PASSPHRASE:?'Root passphrase needed'}
CA_CERT_EXPIRE_IN_DAYS=${CA_CERT_EXPIRE_IN_DAYS:-3650}
COUNTRY_CODE=${COUNTRY_CODE:-''}
STATE_NAME=${STATE_NAME:-''}
LOCALITY_NAME=${LOCALITY_NAME:-''}
ORGANIZATION_NAME=${ORGANIZATION_NAME:-''}
ROOT_CA_COMMON_NAME=${ROOT_CA_COMMON_NAME:?'Root common name needed'}

INTERMEDIATE_PASSPHRASE=${INTERMEDIATE_PASSPHRASE:?'Intermediate passphrase needed'}
INTERMEDIATE_CA_COMMON_NAME=${INTERMEDIATE_CA_COMMON_NAME:?'Intermediate common name needed'}

OCSP_PASSPHRASE=${OCSP_PASSPHRASE:?'OCSP_PASSPHRASE passphrase needed'}
CA_OSCP_SERVER_HTTP_URL="http://${CA_OSCP_SERVER_URL}:${CA_OSCP_SERVER_PORT}"
CA_CRL_SERVER_HTTP_URL="http://${CA_API_SERVER_URL}:${CA_API_SERVER_PLAIN_PORT}/public/ca/intermediate/crl"

CERT_MIN_LIFETIME_IN_DAYS=${CERT_MIN_LIFETIME_IN_DAYS:-1}
CERT_MAX_LIFETIME_IN_DAYS=${CERT_MAX_LIFETIME_IN_DAYS:-365}

mkdir -p /opt/nodepki/data/config

tee /opt/nodepki/data/config/config.yml <<EOF
###
### Server config
###

server:
    ip: 0.0.0.0
    http:
        domain: ${CA_API_SERVER_URL}
        port: ${CA_API_SERVER_PLAIN_PORT}
    ocsp:
        domain: ${CA_OSCP_SERVER_URL}
        port: ${CA_OSCP_SERVER_PORT}

###
### CA config: Passphrase for CA Key
###

ca:
    root:
        passphrase: ${ROOT_PASSPHRASE}
        days: ${CA_CERT_EXPIRE_IN_DAYS}
        country: ${COUNTRY_CODE}
        state: ${STATE_NAME}
        locality: ${LOCALITY_NAME}
        organization: ${ORGANIZATION_NAME}
        commonname: ${ROOT_CA_COMMON_NAME}
    intermediate:
        passphrase: ${INTERMEDIATE_PASSPHRASE}
        days: ${CA_CERT_EXPIRE_IN_DAYS}
        country: ${COUNTRY_CODE}
        state: ${STATE_NAME}
        locality: ${LOCALITY_NAME}
        organization: ${ORGANIZATION_NAME}
        commonname: ${INTERMEDIATE_CA_COMMON_NAME}
        ocsp:
            passphrase: ${OCSP_PASSPHRASE}
            country: ${COUNTRY_CODE}
            url: ${CA_OSCP_SERVER_HTTP_URL}
        crl:
            url: ${CA_CRL_SERVER_HTTP_URL}


###
### Settings for end user certificates
###
cert:
    # E.g.: 1
    lifetime_default: ${CERT_MIN_LIFETIME_IN_DAYS}
    # E.g.: 365
    lifetime_max: ${CERT_MAX_LIFETIME_IN_DAYS}
EOF


cd /opt/nodepki
npm install
node server.js 