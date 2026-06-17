#!/bin/bash

K4GEO_VERSION=v00-24
git clone https://github.com/key4hep/k4geo -b ${K4GEO_VERSION}
cd k4geo
mkdir build_k4geo
cd build_k4geo

source $(scram tool tag dd4hep-core DD4HEP_CORE_BASE)/bin/thisdd4hep.sh
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

K4GEO_PREFIX=${CMSSW_BASE}/install/k4geo
cmake ../ \
  -DCMAKE_INSTALL_PREFIX=${K4GEO_PREFIX} \
  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
  -DPython_INCLUDE_DIR=$(scram tool tag python3 INCLUDE) \
  -DCMAKE_PROJECT_k4geo_INCLUDE=build_k4geo/dd4hep_patch.cmake \
  -DXercesC_INCLUDE_DIR=$(scram tool tag xerces-c INCLUDE) \
  -DXercesC_LIBRARY=$(scram tool tag xerces-c LIBDIR)/libxerces-c.so \
  -DDD4hep_DIR=$(scram tool tag dd4hep-core DD4HEP_CORE_BASE)/cmake \
  -DGeant4_DIR=$(scram tool tag geant4core LIBDIR)/cmake/Geant4 \
  -DLCIO_DIR=$(scram tool tag lcio LIBDIR)/cmake/LCIO \
  -DSIO_DIR=$(scram tool tag lcio LIBDIR)/cmake/SIO \
  -Dpodio_DIR=$(scram tool tag podio LIBDIR)/cmake/podio \
  -DEDM4HEP_DIR=$(scram tool tag edm4hep LIBDIR)/cmake/EDM4HEP

make -j ${C4H_BUILD_CORES} install

# scram
cat << EOF_TOOLFILE > k4geo.xml
<tool name="k4geo" version="${K4GEO_VERSION}">
  <lib name="k4geo"/>
  <lib name="k4geoG4"/>
  <lib name="detectorCommon"/>
  <lib name="detectorSegmentations"/>
  <lib name="detectorSegmentationsPlugin"/>
  <client>
    <environment name="K4GEO_BASE" default="\$CMSSW_BASE/install/k4geo"/>
    <environment name="INCLUDE" default="\$K4GEO_BASE/include"/>
    <environment name="LIBDIR" default="\$K4GEO_BASE/lib"/>
  </client>
  <runtime name="PATH" default="\$K4GEO_BASE/bin" type="path"/>
  <use name="xerces-c"/>
  <use name="dd4hep-core"/>
  <use name="geant4core"/>
  <use name="dd4hep-geant4"/>
  <use name="lcio"/>
  <use name="podio"/>
  <use name="edm4hep"/>
</tool>
EOF_TOOLFILE

mv k4geo.xml ${CMSSW_BASE}/config/toolbox/${SCRAM_ARCH}/tools/selected/
scram setup k4geo
