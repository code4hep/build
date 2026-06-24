#!/bin/bash

STITCHED_VERSION=main_2026_05_27
git clone https://github.com/code4hep/stitched-alpha2 -b ${STITCHED_VERSION} stitched
cd stitched
mkdir build_stitched
cd build_stitched

STITCHED_PREFIX=${INSTALL_DIR}/stitched
CMAKE_PREFIXES=(
$(scram_tag tbb TBB_BASE) \
$(scram_tag root_interface ROOT_INTERFACE_BASE) \
$(scram_tag boost BOOST_BASE) \
$(scram_tag clhep CLHEP_BASE) \
$(scram_tag cpu_features CPU_FEATURES_BASE) \
$(scram_tag tinyxml2 TINYXML2_BASE) \
$(scram_tag py3-pybind11 PY3_PYBIND11_BASE) \
${INSTALL_DIR}/c4h_md5 \
)
cmake ../ \
  -DCMAKE_INSTALL_PREFIX=${STITCHED_PREFIX} \
  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
  -DPython_INCLUDE_DIR=$(scram_tag python3 INCLUDE) \
  -DCMAKE_PREFIX_PATH=$(join_path "${CMAKE_PREFIXES[@]}")

make -j ${C4H_BUILD_CORES} install
