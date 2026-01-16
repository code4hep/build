#!/bin/bash

PODIO_VERSION=v01-06
git clone https://github.com/AIDASoft/podio.git -b ${PODIO_VERSION}
cd podio
mkdir build_podio
cd build_podio

cmake ../ \
  -DCMAKE_INSTALL_PREFIX=${CMSSW_BASE}/install/podio \
  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
  -DUSE_EXTERNAL_CATCH2=OFF \
  -Dfmt_DIR="$(scram tool tag fmt LIBDIR)"/cmake/fmt

make -j ${C4H_BUILD_CORES}
make install

# scram
cat << EOF_TOOLFILE > podio.xml
<tool name="podio" version="${PODIO_VERSION}">
  <lib name="podio"/>
  <lib name="podioIO"/>
  <lib name="podioRootIO"/>
  <client>
    <environment name="PODIO_BASE" default="\$CMSSW_BASE/install/podio"/>
    <environment name="INCLUDE" default="\$PODIO_BASE/include"/>
    <environment name="LIBDIR" default="\$PODIO_BASE/lib64"/>
  </client>
  <runtime name="PODIO" value="\$PODIO_BASE"/>
  <runtime name="ROOT_INCLUDE_PATH" value="\$INCLUDE" type="path"/>
  <runtime name="PYTHON3PATH" default="\$PODIO_BASE/lib/python3.9/site-packages" type="path"/>
</tool>
EOF_TOOLFILE

mv podio.xml ${CMSSW_BASE}/config/toolbox/${SCRAM_ARCH}/tools/selected/
scram setup podio
