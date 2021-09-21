#!/bin/bash
set -e -x

# CLI arguments
PY_VERSION=$1
PY_PEP_425=$2
SYSTEM_PACKAGES=$3
PRE_BUILD_COMMAND=$4
PACKAGE_PATH=$5

# Temporary workaround for LD_LIBRARY_PATH issue. See
# https://github.com/RalfG/python-wheels-manylinux-build/issues/26
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib

cd /github/workspace/"${PACKAGE_PATH}"

if [ -n "$SYSTEM_PACKAGES" ]; then
    yum install -y "${SYSTEM_PACKAGES}"  || { echo "Installing yum package(s) failed."; exit 1; }
fi

if [ -n "$PRE_BUILD_COMMAND" ]; then
    $PRE_BUILD_COMMAND || { echo "Pre-build command failed."; exit 1; }
fi

# Install Rust
curl https://sh.rustup.rs -sSf | sh -s -- -y || { echo "Install Rust failed."; exit 1; }

# Install virtualenv (required for poetry)
/opt/python/"${PY_PEP_425}"/bin/pip install --no-cache-dir virtualenv || { echo "Installing virtualenv failed."; exit 1; }

# Install poetry
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | "/opt/python/${PY_PEP_425}/bin/python" - || { echo "Install poetry failed."; exit 1; }

# Reload path
source "$HOME"/.cargo/env || { echo "Reload path Rust failed."; exit 1; }

# Install dependencies
"$HOME"/.local/bin/poetry update || { echo "Install dependencies failed."; exit 1; }

# Compile wheels
"$HOME"/.local/bin/poetry run maturin build --release -i "${PY_VERSION}" --compatibility "${COMP}" --out ./toaudit || { echo "Building wheels failed."; exit 1; }

# Repair wheels
find ./toaudit -type f -iname "*linux*.whl" -exec sh -c 'for file do /usr/local/bin/auditwheel repair $file -w ./dist; done || { echo "Failed auditwheel repair" ; exit 1; }' sh {} + || exit 1

echo "Succesfully built wheels:"
find ./dist -type f -iname "*manylinux*.whl"
