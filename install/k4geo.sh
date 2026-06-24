#!/bin/bash

K4GEO_VERSION=v00-24
git clone https://github.com/key4hep/k4geo -b ${K4GEO_VERSION}
cd k4geo
mkdir build_k4geo
cd build_k4geo

source $(scram_tag dd4hep-core DD4HEP_CORE_BASE)/bin/thisdd4hep.sh
sed -i 's/find_package(DD4hep 1.31 REQUIRED COMPONENTS DDRec DDG4 DDParsers)/find_package(DD4hep 1.31 REQUIRED COMPONENTS DDRec DDParsers)/' ../CMakeLists.txt
cat << 'EOF' > dd4hep_patch.cmake
add_library(DD4hep::DDG4 STATIC IMPORTED GLOBAL)
set_target_properties(DD4hep::DDG4 PROPERTIES IMPORTED_LOCATION "${DD4hep_DIR}/../lib/libDDG4-static.a")
find_package(Geant4 REQUIRED)
if(TARGET Geant4::Geant4)
  message(STATUS "[PATCH] Linking Geant4 usage requirements to DD4hep::DDG4")
  target_link_libraries(DD4hep::DDG4 INTERFACE Geant4::Geant4)
elseif(Geant4_INCLUDE_DIRS)
  message(STATUS "[PATCH] Fallback: Injecting raw Geant4 variables to DD4hep::DDG4")
  set_property(TARGET DD4hep::DDG4 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${Geant4_INCLUDE_DIRS}")
  target_link_libraries(DD4hep::DDG4 INTERFACE ${Geant4_LIBRARIES})
endif()
EOF

K4GEO_PREFIX=${INSTALL_DIR}/k4geo
cmake ../ \
  -DCMAKE_INSTALL_PREFIX=${K4GEO_PREFIX} \
  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
  -DPython_INCLUDE_DIR=$(scram_tag python3 INCLUDE) \
  -DCMAKE_PROJECT_k4geo_INCLUDE=build_k4geo/dd4hep_patch.cmake \
  -DXercesC_INCLUDE_DIR=$(scram_tag xerces-c INCLUDE) \
  -DXercesC_LIBRARY=$(scram_tag xerces-c LIBDIR)/libxerces-c.so \
  -DBoost_DIR=$(scram_tag boost BOOST_BASE)/cmake/Boost-1.80.0 \
  -DDD4hep_DIR=$(scram_tag dd4hep-core DD4HEP_CORE_BASE)/cmake \
  -DGeant4_DIR=$(scram_tag geant4core LIBDIR)/cmake/Geant4 \
  -DLCIO_DIR=${INSTALL_DIR}/lcio/lib64/cmake/LCIO \
  -DSIO_DIR=${INSTALL_DIR}/lcio/lib64/cmake/SIO \
  -Dpodio_DIR=${INSTALL_DIR}/podio/lib64/cmake/podio \
  -DEDM4HEP_DIR=${INSTALL_DIR}/edm4hep/lib64/cmake/EDM4HEP

make -j ${C4H_BUILD_CORES} install
