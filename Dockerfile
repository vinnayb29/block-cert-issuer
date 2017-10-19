FROM seegno/bitcoind:0.13.2-alpine
MAINTAINER Kim Duffy "kimhd@mit.edu"

COPY . /cert-issuer
COPY ./cert-tools /cert-tools
COPY conf_regtest.ini /etc/cert-issuer/conf.ini

# 2nd line of apk adds are for ethereum
# The last line is a workaround for merkletools requiring an old version of pysha3
RUN apk add --update bash python3 python3-dev ca-certificates linux-headers gcc musl-dev \
  libtool libffi-dev openssl openssl-dev gmp-dev build-base \
    && python3 -m ensurepip \
    && pip3 install --upgrade pip setuptools \
    && mkdir -p /etc/data
 #   && mkdir -p /etc/cert-issuer/data/unsigned_certificates \
 #   && mkdir /etc/cert-issuer/data/blockchain_certificates \
    && mkdir ~/.bitcoin \
    && echo $'rpcuser=foo\nrpcpassword=bar\nrpcport=8332\nregtest=1\nrelaypriority=0\nrpcallowip=127.0.0.1\nrpcconnect=127.0.0.1\n' > /root/.bitcoin/bitcoin.conf \
    && rm -rf /cert-issuer/cert-tools \
    && pip3 install /cert-issuer/. \
    && pip install /cert-tools/. \
    && rm -r /usr/lib/python*/ensurepip \
    && rm -rf /var/cache/apk/* \
    && rm -rf /root/.cache \
    && sed -i.bak s/==1\.0b1/\>=1\.0\.2/g /usr/lib/python3.*/site-packages/merkletools-1.0.2-py3.*.egg-info/requires.txt

ADD bitcoin-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/bitcoin-entrypoint.sh


# ENTRYPOINT bitcoind -daemon && bash
ENTRYPOINT /usr/local/bin/bitcoin-entrypoint.sh

