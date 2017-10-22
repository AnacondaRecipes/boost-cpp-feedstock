#!/bin/bash

set -x -e

. activate "${PREFIX}"

./b2 -q -d+2 \
     python=${PY_VER} \
     -j${CPU_COUNT} \
     --with-python \
     cxxflags="${CXXFLAGS} -Wno-deprecated-declarations" \
     install | tee b2.install-py-${PY_VER}.log 2>&1

# boost.python, when driven via bjam always links to boost_python
# instead of boost_python2 or boost_python3. It also does not add
# any passed --python-buildid; ping @stefanseefeld
pushd "${PREFIX}/lib"
  ln -s libboost_python${PY_VER%.*}.so libboost_python.so
  ln -s libboost_numpy${PY_VER%.}.so libboost_numpy.so
popd
