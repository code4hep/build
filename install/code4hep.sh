#!/bin/bash

source $(which stitched_env.sh)

git clone https://github.com/kpedro88/Code4hep -b reorg_cmake2_rebase
cd Code4hep
mkdir build_Code4hep
cd build_Code4hep

mkdir -p cmake_patch
cat << 'EOF' > cmake_patch/Pythia8Config.cmake
set(Pythia8_FOUND TRUE)
message(STATUS "[PATCH] Creating synthetic Pythia8 target from ${Pythia8_LIBRARY} and ${Pythia8_INCLUDE_DIR}")
add_library(Pythia8::Pythia8 UNKNOWN IMPORTED)
set_target_properties(Pythia8::Pythia8 PROPERTIES
	IMPORTED_LOCATION "${Pythia8_LIBRARY}"
	INTERFACE_INCLUDE_DIRECTORIES "${Pythia8_INCLUDE_DIR}"
)
EOF

CODE4HEP_PREFIX=${INSTALL_DIR}/code4hep
CMAKE_PREFIXES=(
$(scram_tag boost BOOST_BASE) \
$(scram_tag tbb TBB_BASE) \
$(scram_tag root_interface ROOT_INTERFACE_BASE) \
$(scram_tag json JSON_BASE) \
$(scram_tag catch2 CATCH2_BASE) \
$(scram_tag dd4hep-core DD4HEP_CORE_BASE) \
$(scram_tag py3-pybind11 PY3_PYBIND11_BASE) \
$(scram_tag hepmc3 HEPMC3_BASE) \
${PWD}/cmake_patch \
${INSTALL_DIR}/c4h_md5 \
${INSTALL_DIR}/podio \
${INSTALL_DIR}/edm4hep \
${INSTALL_DIR}/stitched \
)

cmake ../ \
  -Wno-dev \
  -DCMAKE_INSTALL_PREFIX=${CODE4HEP_PREFIX} \
  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
  -DPythia8_INCLUDE_DIR=$(scram_tag pythia8 INCLUDE) \
  -DPythia8_LIBRARY=$(scram_tag pythia8 LIBDIR)/libpythia8.so \
  -DCMAKE_PREFIX_PATH=$(join_path "${CMAKE_PREFIXES[@]}") \
  -DPython3_ROOT_DIR=$(scram_tag python3 PYTHON3_BASE) \
  -DCLHEP_ROOT="$(find $(scram_tag clhep LIBDIR) -maxdepth 1 -type d -name "CLHEP*" -print -quit)" \
  -DXercesC_INCLUDE_DIR=$(scram_tag xerces-c INCLUDE) \
  -DXercesC_LIBRARY=$(scram_tag xerces-c LIBDIR)/libxerces-c.so

# make -j ${C4H_BUILD_CORES} install
VERBOSE=1 make -k install
