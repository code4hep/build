#!/bin/bash

source init.sh

cd ${BUILD_DIR}
cmsrel ${CMSSW_VERSION}
cd ${CMSSW_VERSION}/src
cmsenv
git cms-init
mkdir -p ${CMSSW_BASE}/build
mkdir -p ${CMSSW_BASE}/install
cd ${CMSSW_BASE}/build
${SETUP_DIR}/install.sh
