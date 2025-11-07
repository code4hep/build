#!/bin/bash

source init.sh

cd ${BUILD_DIR}
cmsrel ${CMSSW_VERSION}
cd ${CMSSW_VERSION}/src
cmsenv

git cms-init
git remote add c4h git@github.com:code4hep/cmssw
git checkout -b code4hep c4h/code4hep
git cms-addpkg Code4hep

mkdir -p ${CMSSW_BASE}/build
mkdir -p ${CMSSW_BASE}/install
cd ${CMSSW_BASE}/build
${SETUP_DIR}/install.sh

cd ${CMSSW_BASE}/src
scram b -j ${C4H_BUILD_CORES}
