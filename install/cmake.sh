#!/bin/bash

mkdir -p cmake
cd cmake

wget https://github.com/Kitware/CMake/releases/download/v4.1.2/cmake-4.1.2.tar.gz
tar -xzf cmake-4.1.2.tar.gz
cd cmake-4.1.2

# see README file in cmake, bootstrap initializes and builds
# enough of itself that cmake can completely build itself in
# the next step

./bootstrap
make -j ${C4H_BUILD_CORES}
make install
export PATH=$PWD/bin:${PATH}
