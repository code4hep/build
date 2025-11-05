#!/bin/bash

mkdir -p edm4hep
cd edm4hep

git clone https://github.com/key4hep/EDM4hep.git
mkdir build_edm4hep
cd build_edm4hep

cmake ../EDM4hep \
  -DCMAKE_INSTALL_PREFIX=/uscms_data/d2/wdd/extern
  -DROOT_DIR=/cvmfs/cms.cern.ch/el8_amd64_gcc13/lcg/root/6.32.13-2ba92f62034c9fcccda180513e8d0814/cmake \
  -DEDM4HEP_WITH_JSON=OFF \
  -DUSE_EXTERNAL_CATCH2=OFF

make -j ${C4H_BUILD_CORES}
make install
