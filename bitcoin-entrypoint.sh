#!/bin/bash

#create certificate template based on configuration from conf.ini
cd /cert-tools && create-certificate-template -c  /cert-tools/conf.ini 
# generate certificates using certificate template json file and user csv file in sample_data/rosters/  
cd /cert-tools && instantiate-certificate-batch -c /cert-tools/conf.ini 

#Start bitcoind
bitcoind -daemon &

#Create  issuing address inside the cert-issuer container
issuer=`bitcoin-cli getnewaddress`
sed -i.bak "s/<issuing-address>/$issuer/g" /etc/cert-issuer/conf.ini
bitcoin-cli dumpprivkey $issuer > /etc/cert-issuer/pk_issuer.txt

#Generate and print fake bitcoin money in cert-issuer container

bitcoin-cli generate 101
bitcoin-cli getbalance

#Send money to cert issuer
bitcoin-cli sendtoaddress $issuer 5

cert-issuer -c /etc/cert-issuer/conf.ini

bash

#exit 0