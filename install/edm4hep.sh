#!/bin/bash

EDM4HEP_VERSION=v00-99-04
git clone https://github.com/key4hep/EDM4hep.git -b ${EDM4HEP_VERSION}
cd EDM4hep
mkdir build_edm4hep
cd build_edm4hep

EDM4HEP_PREFIX=${CMSSW_BASE}/install/edm4hep
cmake ../ \
  -DCMAKE_INSTALL_PREFIX=${EDM4HEP_PREFIX} \
  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
  -DROOT_DIR="$(scram tool tag root_interface ROOT_INTERFACE_BASE)"/cmake \
  -DEDM4HEP_WITH_JSON=OFF \
  -DUSE_EXTERNAL_CATCH2=OFF

make -j ${C4H_BUILD_CORES}
make install

# manually install test script
mkdir -p ${EDM4HEP_PREFIX}/bin
cp ../scripts/createEDM4hepFile.py ${EDM4HEP_PREFIX}/bin

# scram
cat << EOF_TOOLFILE > edm4hep.xml
<tool name="edm4hep" version="${EDM4HEP_VERSION}">
  <lib name="edm4hep"/>
  <lib name="edm4hepDict"/>
  <client>
    <environment name="EDM4HEP_BASE" default="\$CMSSW_BASE/install/edm4hep"/>
    <environment name="INCLUDE" default="\$EDM4HEP_BASE/include"/>
    <environment name="LIBDIR" default="\$EDM4HEP_BASE/lib64"/>
  </client>
  <runtime name="ROOT_INCLUDE_PATH" value="\$INCLUDE" type="path"/>
  <runtime name="PYTHON3PATH" default="\$EDM4HEP_BASE/lib/python3.9/site-packages" type="path"/>
  <runtime name="PATH" default="\$EDM4HEP_BASE/bin" type="path"/>
</tool>
EOF_TOOLFILE

mv edm4hep.xml ${CMSSW_BASE}/config/toolbox/${SCRAM_ARCH}/tools/selected/
scram setup edm4hep
