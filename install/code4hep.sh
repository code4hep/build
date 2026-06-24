#!/bin/bash

git clone https://github.com/kpedro88/Code4hep -b reorg_cmake
cd Code4hep
mkdir build_Code4hep
cd build_Code4hep

CODE4HEP_PREFIX=${INSTALL_DIR}/code4hep
cmake ../ \
  -DCMAKE_INSTALL_PREFIX=${CODE4HEP_PREFIX} \
  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
  -DBoost_DIR=$(scram_tag boost BOOST_BASE)/cmake/Boost-1.80.0 \
  -DROOT_DIR=$(scram_tag root_interface ROOT_INTERFACE_BASE)/cmake \
  -Dnlohmann_json_DIR=$(scram_tag json JSON_BASE)/cmake/nlohmann_json \
  -DCatch2_DIR=$(scram_tag catch2 LIBDIR)/cmake/Catch2 \
  -DPython_INCLUDE_DIR=$(scram_tag python3 INCLUDE) \
  -DDD4hep_DIR=$(scram_tag dd4hep-core DD4HEP_CORE_BASE)/cmake \
  -Dpodio_DIR=${INSTALL_DIR}/podio/lib64/cmake/podio \
  -DEDM4HEP_DIR=${INSTALL_DIR}/edm4hep/lib64/cmake/EDM4HEP

make -j ${C4H_BUILD_CORES} install
