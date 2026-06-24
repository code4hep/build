#!/bin/bash

GEANT4_VERSION=v11.5.0.beta
git clone https://github.com/Geant4/geant4 -b ${GEANT4_VERSION}
cd geant4
mkdir build_geant4
cd build_geant4

export XERCES_C_DIR=$(scram_tag xerces-c XERCES_C_BASE)

cmake ../ \
      -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/geant4 \
      -DCMAKE_CXX_STANDARD:STRING="20" \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_PREFIX_PATH="${INSTALL_DIR}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DGEANT4_USE_SYSTEM_CLHEP=0 \
      -DGEANT4_USE_SYSTEM_EXPAT=OFF \
      -DGEANT4_INSTALL_DATA=ON \
      -DGEANT4_BUILD_MULTITHREADED=ON \
      -DGEANT4_USE_GDML=ON \
      -DBUILD_SHARED_LIBS=ON \
      -DXERCESC_ROOT_DIR=${XERCES_C_DIR} \
      -DGEANT4_BUILD_TLS_MODEL:STRING="global-dynamic"

make -j ${C4H_BUILD_CORES}
make install
