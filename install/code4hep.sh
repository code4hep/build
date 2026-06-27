#!/bin/bash

git clone https://github.com/kpedro88/Code4hep -b reorg_cmake
cd Code4hep
mkdir build_Code4hep
cd build_Code4hep

cat << 'EOF' > clhep_patch.cmake
# Guard variable to prevent infinite recursion loops
set(_CLHEP_IN_FIND_PACKAGE FALSE CACHE INTERNAL "Global find_package execution fence")

macro(find_package _package)
  message(STATUS "[PATCH] starting patched find_package for ${_package}")
  if(_CLHEP_IN_FIND_PACKAGE)
    # We are already inside our custom wrapper, forward directly to CMake's engine
    message(STATUS "[PATCH] forwarding to CMake")
    _find_package(${ARGV})
  else()
    message(STATUS "[PATCH] getting ready to override")
    # Raise the execution fence
    set(_CLHEP_IN_FIND_PACKAGE TRUE CACHE INTERNAL "")
    # Run the native CMake find_package engine
    message(STATUS "[PATCH] run native CMake find_package")
    _find_package(${ARGV})
    # Force override the variable if it points to the broken CMSSW path
    if("${_package}" STREQUAL "CLHEP" OR CLHEP_INCLUDE_DIR)
      set(_CORRECT_CLHEP "MY_CLHEP_PATH")
      if(CLHEP_INCLUDE_DIR MATCHES "CMSSW")
        message(STATUS "[PATCH] Overriding broken CLHEP path: ${CLHEP_INCLUDE_DIR}")
        message(STATUS "[PATCH] Fixed CLHEP path: ${_CORRECT_CLHEP}")
        set(CLHEP_INCLUDE_DIR "${_CORRECT_CLHEP}" PARENT_SCOPE)
        set(CLHEP_INCLUDE_DIR "${_CORRECT_CLHEP}")
        set(CLHEP_INCLUDE_DIR "${_CORRECT_CLHEP}" CACHE PATH "Force corrected CLHEP include path" FORCE)
      endif()
    endif()
    # Lower the execution fence for the next package search
    set(_CLHEP_IN_FIND_PACKAGE FALSE CACHE INTERNAL "")
  endif()
endmacro()
EOF
sed -i 's~MY_CLHEP_PATH~'$(scram_tag clhep CLHEP_BASE)/include'~g' clhep_patch.cmake

CODE4HEP_PREFIX=${INSTALL_DIR}/code4hep
CMAKE_PREFIXES=(
$(scram_tag boost BOOST_BASE) \
$(scram_tag tbb TBB_BASE) \
$(scram_tag root_interface ROOT_INTERFACE_BASE) \
$(scram_tag json JSON_BASE) \
$(scram_tag catch2 CATCH2_BASE) \
$(scram_tag dd4hep-core DD4HEP_CORE_BASE) \
$(scram_tag py3-pybind11 PY3_PYBIND11_BASE) \
${INSTALL_DIR}/c4h_md5 \
${INSTALL_DIR}/podio \
${INSTALL_DIR}/edm4hep \
${INSTALL_DIR}/stitched \
)
cmake ../ \
  -Wno-dev \
  -DCMAKE_INSTALL_PREFIX=${CODE4HEP_PREFIX} \
  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
  -DCMAKE_PROJECT_Code4hep_INCLUDE=build_Code4hep/clhep_patch.cmake \
  -DCMAKE_PREFIX_PATH=$(join_path "${CMAKE_PREFIXES[@]}") \
  -DPython3_ROOT_DIR=$(scram_tag python3 PYTHON3_BASE) \
  -DCLHEP_ROOT="$(find $(scram_tag clhep LIBDIR) -maxdepth 1 -type d -name "CLHEP*" -print -quit)" \
  -DXercesC_INCLUDE_DIR=$(scram_tag xerces-c INCLUDE) \
  -DXercesC_LIBRARY=$(scram_tag xerces-c LIBDIR)/libxerces-c.so

make -j ${C4H_BUILD_CORES} install
