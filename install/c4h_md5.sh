#!/bin/bash

C4H_MD5_VERSION=56babaebae83437829f8262b7eb8c4a59db9f864
git clone https://github.com/Dr15Jones/c4h_md5
cd c4h_md5
git checkout ${C4H_MD5_VERSION}
mkdir build_c4h_md5
cd build_c4h_md5

C4H_MD5_PREFIX=${INSTALL_DIR}/c4h_md5
cmake ../ \
  -DCMAKE_INSTALL_PREFIX=${C4H_MD5_PREFIX} \
  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE"

make -j ${C4H_BUILD_CORES} install

update_paths $C4H_MD5_PREFIX
