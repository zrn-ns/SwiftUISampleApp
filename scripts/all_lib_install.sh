#!/bin/bash

# https://qiita.com/autotaker1984/items/bc758fcf368c1a167353#%E3%81%8A%E3%81%BE%E3%81%98%E3%81%AA%E3%81%84
set -euxo pipefail

cd `dirname "$0"`

MINTFILE_PATH="../Mintfile"

# https://stackoverflow.com/questions/592620/how-can-i-check-if-a-program-exists-from-a-bash-script
if ! command -v mint &> /dev/null
then
    echo "[ERROR] mint is not installed."
    echo "Please install like below:"
    echo "$ brew install mint"
    exit
fi

mint bootstrap -m "$MINTFILE_PATH"

