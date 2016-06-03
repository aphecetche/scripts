#!/bin/bash

export OS_AUTH_URL=https://keystone.cern.ch:8443/x509/v3
export OS_AUTH_TYPE=v3x509
export OS_IDENTITY_API_VERSION=3
export OS_USER_DOMAIN_ID=default
export OS_CLIENT_CERT=$HOME/private/osclient.pem
export OS_USERNAME=`id -un`
export OS_TENANT_NAME="Personal $OS_USERNAME"
export OS_PROJECT_DOMAIN_ID=default
