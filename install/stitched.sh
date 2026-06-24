#!/bin/bash

STITCHED_VERSION=main_2026_05_27
git clone https://github.com/code4hep/stitched-alpha2 -b ${STITCHED_VERSION} stitched
cd stitched
mkdir build_stitched
cd build_stitched

STITCHED_PREFIX=${INSTALL_DIR}/stitched
cmake ../ \
  -DCMAKE_INSTALL_PREFIX=${STITCHED_PREFIX} \
  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
  -DTBB_DIR=$(scram_tag tbb LIBDIR)/cmake/TBB \
  -DROOT_DIR=$(scram_tag root_interface ROOT_INTERFACE_BASE)/cmake \
  -DBoost_DIR=$(scram_tag boost BOOST_BASE)/cmake/Boost-1.80.0 \
  -DCLHEP_DIR=$(scram_tag clhep LIBDIR)/CLHEP-2.4.7.1 \
  -DPython_INCLUDE_DIR=$(scram_tag python3 INCLUDE) \
  -DCpuFeatures_DIR=$(scram_tag cpu_features LIBDIR)/cmake/CpuFeatures \
  -Dtinyxml2_DIR=$(scram_tag tinyxml2 LIBDIR)/cmake/tinyxml2 \
  -Dpybind11_DIR=$(scram_tag py3-pybind11 PY3_PYBIND11_BASE)/share/cmake/pybind11 \
  -Dc4h_md5_DIR=${C4H_MD5_ROOT}/lib64/cmake/c4h_md5

make -j ${C4H_BUILD_CORES} install
