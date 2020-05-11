#!/bin/bash

PYVERSION=${1}
if [ -z "${PYVERSION}" ]; then
    PYVERSION=3.8.0
fi

if [ -d ${HOME}/.pyenv/versions/${PYVERSION} ]; then
    echo "${PYVERSION} is already installed"
    exit 1
fi

pyenv install ${PYVERSION}
