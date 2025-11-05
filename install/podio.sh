#!/bin/bash

mkdir -p podio
cd podio

git clone https://github.com/AIDASoft/podio.git
mkdir build_podio
cd build_podio

cmake ../podio \
  -DUSE_EXTERNAL_CATCH2=OFF
  -Dfmt_DIR=/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/fmt/10.2.1-31d67b0504b4ba2262f03d3c5cad83c1/lib/cmake/fmt

make -j ${C4H_BUILD_CORES}
make install
export PODIO=${PWD}

# todo: setup scram tool

