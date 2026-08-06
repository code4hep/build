#!/bin/bash

source init.sh

while getopts "d" opt; do
	case "$opt" in
		d)
			# for CMake externals
			export CMAKE_BUILD_TYPE=Debug
			# for scram
			export USER_CXXFLAGS="-g -Og"
		;;
	esac
done

cd ${BUILD_DIR}
cmsrel ${CMSSW_VERSION}
cd ${CMSSW_VERSION}/src
cmsenv

cd ${BUILD_DIR}

mkdir -p tmp
mkdir -p install
cd tmp
${SETUP_DIR}/install.sh
