#!/bin/bash

# https://qiita.com/autotaker1984/items/bc758fcf368c1a167353#%E3%81%8A%E3%81%BE%E3%81%98%E3%81%AA%E3%81%84
set -euxo pipefail

cd `dirname "$0"`

cd ..

mint run swiftformat . --swiftversion 5.7
