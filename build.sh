#!/usr/bin/env bash

set -e

echo ""
echo "run 'pip install pipx'"

pip install pipx

echo ""
echo "run 'pipx install portable-python'"

pipx install portable-python

echo ""
echo "run 'portable-python build ${PYTHON_VERSION} -m openssl'"

portable-python build ${PYTHON_VERSION} -m openssl

echo ""
echo "run 'build/ppp-marker/${PYTHON_VERSION}/bin/pip3 install -r ${GITHUB_WORKSPACE}/requirements.txt'"

build/ppp-marker/${PYTHON_VERSION}/bin/pip3 install -r ${GITHUB_WORKSPACE}/requirements.txt


echo ""
echo "run 'portable-python recompress build/ppp-marker/${PYTHON_VERSION} gz'"

portable-python recompress build/ppp-marker/${PYTHON_VERSION} gz
