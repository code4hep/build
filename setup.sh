#!/bin/bash

SETUP_DIR="$PWD"
BUILD_DIR=$(readlink -f "$SETUP_DIR"/..)

cd ${BUILD_DIR}
source /cvmfs/cms.cern.ch/cmsset_default.sh
cmsrel CMSSW_16_0_0_pre2
cd CMSSW_16_0_0_pre2/src
cmsenv
mkdir -p ${CMSSW_BASE}/build
cd ${CMSSW_BASE}/build
${SETUP_DIR}/install.sh
