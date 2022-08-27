#!/bin/sh
set -euxo pipefail
cd `dirname "$0"`

PROJECT_ROOT_DIR="../"

cd $PROJECT_ROOT_DIR

find . -type f -name "Localizable.strings" \
    | xargs -IXXXX sh -c 'sed -i "" -e "/^\"/!d" XXXX; sort -u XXXX -o XXXX'

