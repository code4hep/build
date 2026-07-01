#!/bin/bash

source $(which stitched_env.sh)

git clone https://github.com/kpedro88/Code4hep -b reorg_cmake
cd Code4hep
mkdir build_Code4hep
cd build_Code4hep

CODE4HEP_PREFIX=${INSTALL_DIR}/code4hep
CMAKE_PREFIXES=(
$(scram_tag boost BOOST_BASE) \
$(scram_tag tbb TBB_BASE) \
$(scram_tag root_interface ROOT_INTERFACE_BASE) \
$(scram_tag json JSON_BASE) \
$(scram_tag catch2 CATCH2_BASE) \
$(scram_tag dd4hep-core DD4HEP_CORE_BASE) \
$(scram_tag py3-pybind11 PY3_PYBIND11_BASE) \
${INSTALL_DIR}/c4h_md5 \
${INSTALL_DIR}/podio \
${INSTALL_DIR}/edm4hep \
${INSTALL_DIR}/stitched \
)
cmake ../ \
  -Wno-dev \
  -DCMAKE_INSTALL_PREFIX=${CODE4HEP_PREFIX} \
  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
  -DCMAKE_PREFIX_PATH=$(join_path "${CMAKE_PREFIXES[@]}") \
  -DPython3_ROOT_DIR=$(scram_tag python3 PYTHON3_BASE) \
  -DCLHEP_ROOT="$(find $(scram_tag clhep LIBDIR) -maxdepth 1 -type d -name "CLHEP*" -print -quit)" \
  -DXercesC_INCLUDE_DIR=$(scram_tag xerces-c INCLUDE) \
  -DXercesC_LIBRARY=$(scram_tag xerces-c LIBDIR)/libxerces-c.so

# make -j ${C4H_BUILD_CORES} install
VERBOSE=1 make -k install
