#!/bin/bash

git clone https://github.com/Dr15Jones/c4h_md5
cd c4h_md5
mkdir build_c4h_md5
cd build_c4h_md5

C4H_MD5_PREFIX=${INSTALL_DIR}/c4h_md5
cmake ../ \
  -DCMAKE_INSTALL_PREFIX=${K4GEO_PREFIX} \
  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE"

make -j ${C4H_BUILD_CORES} install
