#!/bin/bash

set -x -e

. activate "${PREFIX}"

if [[ ${HOST} =~ .*darwin.* ]]; then
    TOOLSET=clang
elif [[ ${HOST} =~ .*linux.* ]]; then
    TOOLSET=gcc
fi

cat <<EOF > ${SRC_DIR}/tools/build/src/site-config.jam
using ${TOOLSET} : custom : ${CXX} ;
EOF

./b2 -q \
     install | tee b2.install.log 2>&1

# Remove Python headers as we don't build Boost.Python.
rm "${PREFIX}/include/boost/python.hpp"
rm -r "${PREFIX}/include/boost/python"