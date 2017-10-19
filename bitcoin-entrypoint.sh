#!/bin/bash

#create certificate template based on configuration from conf.ini
cd /cert-tools && create-certificate-template -c  /cert-tools/conf.ini 
# generate certificates using certificate template json file and user csv file in sample_data/rosters/  
cd /cert-tools && instantiate-certificate-batch -c /cert-tools/conf.ini 

#Start bitcoind
bitcoind -daemon && bash /usr/local/bin/generate-signed-certificates.sh

#exit 0