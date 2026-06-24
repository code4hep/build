#!/bin/bash

LCIO_VERSION=v02-23-02
git clone https://github.com/iLCSoft/LCIO.git --branch ${LCIO_VERSION}
cd LCIO
mkdir build_lcio
cd build_lcio

LCIO_PREFIX=${INSTALL_DIR}/lcio
cmake ../ \
  -DCMAKE_INSTALL_PREFIX=${LCIO_PREFIX} \
  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
  -DROOT_DIR="$(scram_tag root_interface ROOT_INTERFACE_BASE)"/cmake \
  -DCLHEP_DIR="$(find $(scram_tag clhep LIBDIR) -maxdepth 1 -type d -name "CLHEP*" -print -quit)"

make -j ${C4H_BUILD_CORES} install
