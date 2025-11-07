#!/bin/bash

source init.sh

cd ${BUILD_DIR}
cmsrel ${CMSSW_VERSION}
cd ${CMSSW_VERSION}/src
cmsenv
git cms-init
git remote add c4h git@github.com:code4hep/cmssw
mkdir -p ${CMSSW_BASE}/build
mkdir -p ${CMSSW_BASE}/install
cd ${CMSSW_BASE}/build
${SETUP_DIR}/install.sh
