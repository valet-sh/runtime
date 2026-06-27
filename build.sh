#!/usr/bin/env bash

set -e

ARCH=$(uname -m)
INSTALL_DIR="/usr/local/valet-sh"
VENV_DIR="${INSTALL_DIR}/venv"

# Determine platform triple for python-build-standalone
if [[ "$OSTYPE" == "darwin"* ]]; then
    TRIPLE="aarch64-apple-darwin"
elif [[ "$ARCH" == "x86_64" ]]; then
    TRIPLE="x86_64-unknown-linux-gnu"
else
    echo "Unsupported platform: $OSTYPE / $ARCH"
    exit 1
fi

echo ""
echo "Creating install directory: ${INSTALL_DIR}"
sudo mkdir -p "${INSTALL_DIR}"
sudo chmod 777 "${INSTALL_DIR}"
mkdir -p "${VENV_DIR}"

echo ""
echo "Fetching latest Python 3.12 release from python-build-standalone..."
RELEASE_DATA=$(curl -s -H "Authorization: Bearer ${GITHUB_TOKEN}" "https://api.github.com/repos/astral-sh/python-build-standalone/releases/latest")
PYTHON_URL=$(echo "$RELEASE_DATA" | \
    jq -r '.assets[].browser_download_url' | \
    grep -E "cpython-3\.12\.[0-9]+%2B[0-9]+-${TRIPLE}-install_only\.tar\.gz$" | \
    head -1)

if [[ -z "$PYTHON_URL" ]]; then
    echo "Error: Could not find Python 3.12 install_only asset for ${TRIPLE}"
    exit 1
fi

echo "Downloading: $(basename "$PYTHON_URL")"
curl -fL "${PYTHON_URL}" | tar xz --strip-components=1 -C "${VENV_DIR}"

echo ""
echo "Installing dependencies..."
"${VENV_DIR}/bin/python3" -m pip install --no-cache-dir -r "${GITHUB_WORKSPACE}/requirements.txt"
