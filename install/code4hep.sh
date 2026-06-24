#!/bin/bash

git clone https://github.com/kpedro88/Code4hep -b reorg_cmake
cd Code4hep
mkdir build_Code4hep
cd build_Code4hep

CODE4HEP_PREFIX=${INSTALL_DIR}/code4hep
CMAKE_PREFIXES=(
$(scram_tag boost BOOST_BASE) \
$(scram_tag root_interface ROOT_INTERFACE_BASE) \
$(scram_tag json JSON_BASE) \
$(scram_tag catch2 CATCH2_BASE) \
$(scram_tag dd4hep-core DD4HEP_CORE_BASE) \
${INSTALL_DIR}/podio \
${INSTALL_DIR}/edm4hep \
)
cmake ../ \
  -DCMAKE_INSTALL_PREFIX=${CODE4HEP_PREFIX} \
  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
  -DCMAKE_PREFIX_PATH=$(join_path "${CMAKE_PREFIXES[@]}") \
  -DPython_INCLUDE_DIR=$(scram_tag python3 INCLUDE)

make -j ${C4H_BUILD_CORES} install
