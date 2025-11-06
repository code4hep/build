#!/bin/bash

wget https://github.com/Kitware/CMake/releases/download/v4.1.2/cmake-4.1.2.tar.gz
tar -xzf cmake-4.1.2.tar.gz
cd cmake-4.1.2

# see README file in cmake, bootstrap initializes and builds
# enough of itself that cmake can completely build itself in
# the next step

./bootstrap --prefix=${CMSSW_BASE}/install/cmake/
make -j ${C4H_BUILD_CORES}
make install

# scram
cat << 'EOF_TOOLFILE' > cmake.xml
<tool name="cmake" version="4.1.2">
  <client>
    <environment name="CMAKE_BASE" default="$CMSSW_BASE/install/cmake"/>
  </client>
  <runtime name="PATH" value="$CMAKE_BASE/bin" type="path"/>
</tool>
EOF_TOOLFILE

mv cmake.xml ${CMSSW_BASE}/config/toolbox/${SCRAM_ARCH}/tools/selected/
scram setup cmake
