#!/bin/bash

STITCHED_EXAMPLE_VERSION=example-2026-08-21
git clone https://github.com/code4hep/stitched-example
cd stitched-example
git checkout ${STITCHED_EXAMPLE_VERSION}
mkdir build_stitched_example
cd build_stitched_example

STITCHED_EXAMPLE_PREFIX=${INSTALL_DIR}/stitched_example
CMAKE_PREFIXES=(
$(scram_tag boost BOOST_BASE) \
$(scram_tag tbb TBB_BASE) \
$(scram_tag root_interface ROOT_INTERFACE_BASE) \
$(scram_tag json JSON_BASE) \
$(scram_tag catch2 CATCH2_BASE) \
$(scram_tag py3-pybind11 PY3_PYBIND11_BASE) \
${INSTALL_DIR}/c4h_md5 \
${INSTALL_DIR}/stitched \
)

cmake ../ \
  -DCMAKE_INSTALL_PREFIX=${STITCHED_EXAMPLE_PREFIX} \
  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
  -DCMAKE_PREFIX_PATH=$(join_path "${CMAKE_PREFIXES[@]}") \
  -DCLHEP_ROOT="$(find $(scram_tag clhep LIBDIR) -maxdepth 1 -type d -name "CLHEP*" -print -quit)"

make -j ${C4H_BUILD_CORES} install

update_paths ${STITCHED_EXAMPLE_PREFIX}
