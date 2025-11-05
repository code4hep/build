#!/bin/bash

source common.sh
source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -e "$CMSSW_DIR" ]; then
	cd ${CMSSW_DIR}/src
	cmsenv
fi
