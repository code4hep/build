#!/bin/bash

git clone https://github.com/AIDASoft/podio.git
cd podio
mkdir build_podio
cd build_podio

cmake ../ \
  -DCMAKE_INSTALL_PREFIX=${CMSSW_BASE}/install/podio
  -DUSE_EXTERNAL_CATCH2=OFF
  -Dfmt_DIR=/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/fmt/10.2.1-31d67b0504b4ba2262f03d3c5cad83c1/lib/cmake/fmt

make -j ${C4H_BUILD_CORES}
make install

# scram
cat << 'EOF_TOOLFILE' > podio.xml
<tool name="podio" version="v01-06">
  <lib name="podioIO"/>
  <client>
    <environment name="PODIO_BASE" default="$CMSSW_BASE/install/podio"/>
    <environment name="INCLUDE" default="$PODIO_BASE/include"/>
    <environment name="LIBDIR" default="$PODIO_BASE/lib64"/>
  </client>
  <runtime name="PODIO" value="$PODIO_BASE"/>
</tool>
EOF_TOOLFILE

mv podio.xml ${CMSSW_BASE}/config/toolbox/${SCRAM_ARCH}/tools/selected/
scram setup podio

