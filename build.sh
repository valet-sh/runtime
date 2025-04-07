#!/usr/bin/env bash

set -e

ARCH=$(uname -m)
HOMEBREW_PREFIX="/usr/local"


echo ""
echo "run 'mkdir /usr/local/valet-sh'"

sudo mkdir /usr/local/valet-sh

sudo chmod 777 /usr/local/valet-sh

echo ""
echo "run '/usr/bin/python3 -m venv venv'"

cd /usr/local/valet-sh

if [[ "$OSTYPE" == "darwin"* ]] && [[ "$ARCH" == "arm"* ]]; then
  HOMEBREW_PREFIX="/opt/homebrew"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    # check if brew is installed
    if ! command -v ${HOMEBREW_PREFIX}/bin/brew &> /dev/null
        then
            echo " - brew could not be found. Installing..."
            yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            export CPPFLAGS=-I${HOMEBREW_PREFIX}/opt/openssl/include
            export LDFLAGS=-L${HOMEBREW_PREFIX}/opt/openssl/lib
        fi

    echo " - install required brew packages"
    ${HOMEBREW_PREFIX}/bin/brew install openssl rust python@3.12

    ${HOMEBREW_PREFIX}/bin/python3.12 -m venv venv
else
  /usr/bin/python3 -m venv venv
fi

echo ""
echo "run 'pip3 install -r ${GITHUB_WORKSPACE}/requirements.txt'"

source venv/bin/activate
pip3 install -r ${GITHUB_WORKSPACE}/requirements.txt

deactivate
