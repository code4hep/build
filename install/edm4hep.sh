#!/bin/bash

git clone https://github.com/key4hep/EDM4hep.git
cd EDM4hep
mkdir build_edm4hep
cd build_edm4hep

cmake ../ \
  -DCMAKE_INSTALL_PREFIX=${CMSSW_BASE}/install/edm4hep \
  -DROOT_DIR="$(scram tool tag root_interface ROOT_INTERFACE_BASE)"/cmake \
  -DEDM4HEP_WITH_JSON=OFF \
  -DUSE_EXTERNAL_CATCH2=OFF

make -j ${C4H_BUILD_CORES}
make install

# scram
cat << 'EOF_TOOLFILE' > edm4hep.xml
<tool name="edm4hep" version="v00-99-04">
  <lib name=""/>
  <client>
    <environment name="EDM4HEP_BASE" default="$CMSSW_BASE/install/edm4hep"/>
    <environment name="INCLUDE" default="$EDM4HEP_BASE/include"/>
    <environment name="LIBDIR" default="$EDM4HEP_BASE/lib64"/>
  </client>
</tool>
EOF_TOOLFILE

mv edm4hep.xml ${CMSSW_BASE}/config/toolbox/${SCRAM_ARCH}/tools/selected/
scram setup edm4hep

