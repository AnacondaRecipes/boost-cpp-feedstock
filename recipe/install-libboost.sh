#!/bin/bash

set -x -e

. activate "${PREFIX}"

if [[ ${HOST} =~ .*darwin.* ]]; then
    TOOLSET=clang
elif [[ ${HOST} =~ .*linux.* ]]; then
    TOOLSET=gcc
fi

# http://www.boost.org/build/doc/html/bbv2/tasks/crosscompile.html
cat <<EOF > ${SRC_DIR}/tools/build/src/site-config.jam
import os ;
local CXXFLAGS = [ os.environ CXXFLAGS ] ;
local LDFLAGS = [ os.environ LDFLAGS ] ;
using ${TOOLSET} : custom : ${CXX} : <compileflags>-I${PREFIX}/include \$(CXXFLAGS) -Wno-deprecated-declarations <linkflags>-L${PREFIX}/lib \$(LDFLAGS) ;
EOF

./b2 -q -d+2 \
     install | tee b2.install.log 2>&1

# Remove Python headers as we don't build Boost.Python.
rm "${PREFIX}/include/boost/python.hpp"
rm -r "${PREFIX}/include/boost/python"

cp ./b2 "${PREFIX}/bin/b2" || exit 1
pushd "${PREFIX}/bin"
    ln -s b2 bjam || exit 1
popd

mkdir -p "${PREFIX}/share/boost-build"
cp -rf tools/build/* "${PREFIX}/share/boost-build"

# We have patched build-system.jam to use this file when
# the CONDA_BUILD environment variable is set.
mkdir -p "${PREFIX}/etc"
cp ${SRC_DIR}/tools/build/src/site-config.jam "${PREFIX}/etc"
