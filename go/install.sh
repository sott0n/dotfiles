#!/bin/bash

GOVERSION=${1}
if [ -z "${GOVERSION}" ]; then
    GOVERSION=1.17.8
fi

if [ -d ${HOME}/.go/${GOVERSION} ]; then
    echo "${GOVERSION} is already installed"
    exit 1
fi

rm -fr ${GOHOME}/pkg
mkdir -p ${HOME}/.go/${GOVERSION}

if [ "$(uname)" == 'Darwin' ]; then
  curl https://storage.googleapis.com/golang/go${GOVERSION}.darwin-amd64.tar.gz \
    | tar xvzf - -C ${HOME}/.go/${GOVERSION}/ --strip-components=1
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  curl https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz \
    | tar xvzf - -C ${HOME}/.go/${GOVERSION}/ --strip-components=1
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

echo $GOVERSION > ${HOME}/.go/.goversion

