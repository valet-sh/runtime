#!/usr/bin/env bash

set -e

echo ""
echo "run 'mkdir /usr/local/valet-sh'"

sudo mkdir /usr/local/valet-sh

sudo chmod 777 /usr/local/valet-sh

echo ""
echo "run 'python3 -m venv venv'"

cd /usr/local/valet-sh
python3 -m venv venv

echo ""
echo "run 'pip3 install -r ${GITHUB_WORKSPACE}/requirements.txt'"

source venv/bin/activate
pip3 install -r ${GITHUB_WORKSPACE}/requirements.txt
