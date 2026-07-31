#!/bin/bash

GEANT4_VERSION=v11.5.0.beta
git clone https://github.com/Geant4/geant4 -b ${GEANT4_VERSION}
cd geant4
mkdir build_geant4
cd build_geant4

export XERCES_C_DIR=$(scram tool tag xerces-c XERCES_C_BASE)

cmake ../ \
      -DCMAKE_INSTALL_PREFIX=${CMSSW_BASE}/install/geant4 \
      -DCMAKE_CXX_STANDARD:STRING="20" \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_PREFIX_PATH="${INSTALL_DIR}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DGEANT4_USE_SYSTEM_CLHEP=0 \
      -DGEANT4_USE_SYSTEM_EXPAT=OFF \
      -DGEANT4_INSTALL_DATA=ON \
      -DGEANT4_BUILD_MULTITHREADED=ON \
      -DGEANT4_USE_GDML=ON \
      -DBUILD_SHARED_LIBS=ON \
      -DXERCESC_ROOT_DIR=${XERCES_C_DIR} \
      -DGEANT4_BUILD_TLS_MODEL:STRING="global-dynamic"

make -j ${C4H_BUILD_CORES}
make install

# scram xml
#
# geant4_interface
#
cat << EOF_TOOLFILE > geant4_interface.xml
<tool name="geant4_interface" version="${GEANT4_VERSION}">
  <info url="https://geant4.web.cern.ch/"/>
  <flags CXXFLAGS="-ftls-model=global-dynamic -pthread"/>
  <client>
    <environment name="GEANT4_INTERFACE_BASE" default="\$CMSSW_BASE/install/geant4"/>
    <environment name="INCLUDE" default="\$GEANT4_INTERFACE_BASE/include/Geant4"/>
    <environment name="INCLUDE" default="\$GEANT4_INTERFACE_BASE/include"/>
  </client>
  <runtime name="ROOT_INCLUDE_PATH"  value="\$INCLUDE" type="path"/>
  <flags cppdefines="GNU_GCC G4V9"/>
  <use name="clhep"/>
  <use name="zlib"/>
  <use name="expat"/>
  <use name="xerces-c"/>
  <use name="root_cxxdefaults"/>
</tool>
EOF_TOOLFILE
#
# geant4core
#
cat << EOF_TOOLFILE > geant4core.xml
<tool name="geant4core" version="${GEANT4_VERSION}">
  <lib name="G4digits_hits"/>
  <lib name="G4error_propagation"/>
  <lib name="G4event"/>
  <lib name="G4geometry"/>
  <lib name="G4global"/>
  <lib name="G4graphics_reps"/>
  <lib name="G4intercoms"/>
  <lib name="G4interfaces"/>
  <lib name="G4materials"/>
  <lib name="G4parmodels"/>
  <lib name="G4particles"/>
  <lib name="G4geomtext"/>
  <lib name="G4mctruth"/>
  <lib name="G4gdml"/>
  <lib name="G4physicslists"/>
  <lib name="G4processes_core"/>
  <lib name="G4processes_hadronic"/>
  <lib name="G4readout"/>
  <lib name="G4run"/>
  <lib name="G4tracking"/>
  <lib name="G4track"/>
  <lib name="G4analysis"/>
  <lib name="G4ptl"/>
  <client>
    <environment name="GEANT4CORE_BASE" default="\$CMSSW_BASE/install/geant4"/>
    <environment name="LIBDIR" default="\$GEANT4CORE_BASE/lib"/>
    <environment name="G4LIB" value="\$LIBDIR"/>
  </client>
  <flags cppdefines="GNU_GCC G4V9"/>
  <use name="geant4_interface"/>
</tool>
EOF_TOOLFILE
#
# geant4vis
#
cat << EOF_TOOLFILE > geant4vis.xml
<tool name="geant4vis" version="${GEANT4_VERSION}">
  <lib name="G4FR"/>
  <lib name="G4modeling"/>
  <lib name="G4RayTracer"/>
  <lib name="G4Tree"/>
  <lib name="G4vis_management"/>
  <lib name="G4VRML"/>
  <lib name="G4GMocren"/>
  <use name="geant4core"/>
</tool>
EOF_TOOLFILE
#
# geant4data
#
cat << EOF_TOOLFILE > geant4data.xml
<tool name="geant4data" version="${GEANT4_VERSION}">
  <client>
    <environment name="GEANT4DATA_BASE" default="\$CMSSW_BASE/install/geant4/share/Geant4/data"/>
  </client>
  <runtime name="G4ABLADATA" value="\$GEANT4DATA_BASE/G4ABLA3.3" type="path"/>
  <runtime name="G4LEDATA" value="\$GEANT4DATA_BASE/G4EMLOW9.0" type="path"/>
  <runtime name="G4ENSDFSTATEDATA" value="\$GEANT4DATA_BASE/G4ENSDFSTATE3.0" type="path"/>
  <runtime name="G4INCLDATA" value="\$GEANT4DATA_BASE/G4INCL1.3" type="path"/>
  <runtime name="G4NEUTRONHPDATA" value="\$GEANT4DATA_BASE/G4NDL4.7.1" type="path"/>
  <runtime name="G4PARTICLEXSDATA" value="\$GEANT4DATA_BASE/G4PARTICLEXS4.2" type="path"/>
  <runtime name="G4LEVELGAMMADATA" value="\$GEANT4DATA_BASE/PhotonEvaporation6.1.2" type="path"/>
  <runtime name="G4RADIOACTIVEDATA" value="\$GEANT4DATA_BASE/RadioactiveDecay6.1.2" type="path"/>
  <runtime name="G4REALSURFACEDATA" value="\$GEANT4DATA_BASE/RealSurface2.2" type="path"/>
  <runtime name="G4SAIDXSDATA" value="\$GEANT4DATA_BASE/G4SAIDDATA2.0" type="path"/>
</tool>
EOF_TOOLFILE
#
# geant4
#
cat << EOF_TOOLFILE > geant4.xml
<tool name="geant4" version="${GEANT4_VERSION}">
  <info url="https://geant4.web.cern.ch/"/>
  <use name="geant4core"/>
  <use name="geant4vis"/>
</tool>
EOF_TOOLFILE
#
# scram setup
#
for g4 in geant4_interface geant4core geant4vis geant4data geant4 ; do
  mv ${g4}.xml ${CMSSW_BASE}/config/toolbox/${SCRAM_ARCH}/tools/selected/
  scram setup ${g4}
done
