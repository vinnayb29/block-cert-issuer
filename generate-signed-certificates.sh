#!/bin/bash

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