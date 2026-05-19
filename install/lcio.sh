#!/bin/bash

LCIO_VERSION=v02-23-02
git clone https://github.com/iLCSoft/LCIO.git --branch ${LCIO_VERSION}
cd LCIO
mkdir build_lcio
cd build_lcio

LCIO_PREFIX=${CMSSW_BASE}/install/lcio
cmake ../ \
  -DCMAKE_INSTALL_PREFIX=${LCIO_PREFIX} \
  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
  -DROOT_DIR="$(scram tool tag root_interface ROOT_INTERFACE_BASE)"/cmake \
  -DCLHEP_DIR="$(find $(scram tool tag clhep LIBDIR) -maxdepth 1 -type d -name "CLHEP*" -print -quit)"

make -j ${C4H_BUILD_CORES} install

# scram
cat << EOF_TOOLFILE > lcio.xml
<tool name="lcio" version="${LCIO_VERSION}">
  <lib name="lcio"/>
  <lib name="lcioDict"/>
  <lib name="sio"/>
  <client>
    <environment name="LCIO_BASE" default="\$CMSSW_BASE/install/lcio"/>
    <environment name="INCLUDE" default="\$LCIO_BASE/include"/>
    <environment name="LIBDIR" default="\$LCIO_BASE/lib64"/>
  </client>
  <runtime name="PYTHON3PATH" default="\$LCIO_BASE/python" type="path"/>
  <runtime name="PATH" default="\$LCIO_BASE/bin" type="path"/>
  <use name="root_cxxdefaults"/>
  <use name="root"/>
  <use name="clhep"/>
</tool>
EOF_TOOLFILE

mv lcio.xml ${CMSSW_BASE}/config/toolbox/${SCRAM_ARCH}/tools/selected/
scram setup lcio

