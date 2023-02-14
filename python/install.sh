#!/bin/bash

sudo apt install -y zlib1g-dev sqlite3 libssl-dev
curl https://pyenv.run | bash

PYVERSION=${1}
if [ -z "${PYVERSION}" ]; then
    PYVERSION=3.11.1
fi

if [ -d ${HOME}/.pyenv/versions/${PYVERSION} ]; then
    echo "${PYVERSION} is already installed"
    exit 1
fi

pyenv install ${PYVERSION}
