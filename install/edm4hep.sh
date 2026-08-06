#!/bin/bash

EDM4HEP_VERSION=v00-99-04
git clone https://github.com/key4hep/EDM4hep.git -b ${EDM4HEP_VERSION}
cd EDM4hep
mkdir build_edm4hep
cd build_edm4hep

EDM4HEP_PREFIX=${INSTALL_DIR}/edm4hep
CMAKE_PREFIXES=(
$(scram_tag root_interface ROOT_INTERFACE_BASE) \
)
cmake ../ \
  -DCMAKE_INSTALL_PREFIX=${EDM4HEP_PREFIX} \
  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
  -DCMAKE_PREFIX_PATH=$(join_path "${CMAKE_PREFIXES[@]}") \
  -Dpodio_ROOT=${INSTALL_DIR}/podio/lib64/cmake \
  -DEDM4HEP_WITH_JSON=OFF \
  -DUSE_EXTERNAL_CATCH2=OFF

make -j ${C4H_BUILD_CORES}
make install

# manually install test script
mkdir -p ${EDM4HEP_PREFIX}/bin
cp ../scripts/createEDM4hepFile.py ${EDM4HEP_PREFIX}/bin

update_paths ${EDM4HEP_PREFIX}
