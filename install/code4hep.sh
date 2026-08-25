#!/bin/bash

source $(which stitched_env.sh)

git clone https://github.com/code4hep/Code4hep
cd Code4hep
mkdir build_Code4hep
cd build_Code4hep

PATCH_DIR=cmake_patch
mkdir -p ${PATCH_DIR}

cat << 'EOF' > ${PATCH_DIR}/Pythia8Config.cmake
set(Pythia8_FOUND TRUE)
message(STATUS "[PATCH] Creating synthetic Pythia8 target from ${Pythia8_LIBRARY} and ${Pythia8_INCLUDE_DIR}")
add_library(Pythia8::Pythia8 UNKNOWN IMPORTED)
set_target_properties(Pythia8::Pythia8 PROPERTIES
	IMPORTED_LOCATION "${Pythia8_LIBRARY}"
	INTERFACE_INCLUDE_DIRECTORIES "${Pythia8_INCLUDE_DIR}"
)
EOF

cat << 'EOF' > ${PATCH_DIR}/Geant4Config.cmake
# 1. Directly include the real Geant4Config file, skipping the search engine entirely
include("MY_GEANT4_DIR/Geant4Config.cmake")

# 2. Create the global target using the newly loaded variables
if(Geant4_FOUND AND NOT TARGET Geant4::Geant4)
    message(STATUS "[Proxy] Creating global target Geant4::Geant4 from \${Geant4_LIBRARIES} as IMPORTED")

    # By defining it as INTERFACE IMPORTED GLOBAL, CMake treats it like a system target
    add_library(Geant4::Geant4 INTERFACE IMPORTED GLOBAL)

    # Directly link the dynamic Geant4 libraries to it
    target_link_libraries(Geant4::Geant4 INTERFACE ${Geant4_LIBRARIES})
endif()
EOF
sed -i 's~MY_GEANT4_DIR~'${INSTALL_DIR}/geant4/lib/cmake/Geant4'~' ${PATCH_DIR}/Geant4Config.cmake

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
${PWD}/${PATCH_DIR} \
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
  -DPython_INCLUDE_DIR=$(scram_tag python3 INCLUDE) \
  -DPython3_ROOT_DIR=$(scram_tag python3 PYTHON3_BASE) \
  -DCLHEP_ROOT="$(find $(scram_tag clhep LIBDIR) -maxdepth 1 -type d -name "CLHEP*" -print -quit)" \
  -DXercesC_INCLUDE_DIR=$(scram_tag xerces-c INCLUDE) \
  -DXercesC_LIBRARY=$(scram_tag xerces-c LIBDIR)/libxerces-c.so

# make -j ${C4H_BUILD_CORES} install
VERBOSE=1 make -k install
