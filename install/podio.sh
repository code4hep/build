#!/bin/bash

PODIO_VERSION=v01-06
git clone https://github.com/AIDASoft/podio.git -b ${PODIO_VERSION}
cd podio
mkdir build_podio
cd build_podio

cmake ../ \
  -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/podio \
  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
  -DUSE_EXTERNAL_CATCH2=OFF \
  -Dfmt_DIR="$(scram_tag fmt LIBDIR)"/cmake/fmt

make -j ${C4H_BUILD_CORES}
make install
