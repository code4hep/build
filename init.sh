#!/bin/bash

source common.sh
source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -e "$CMSSW_DIR" ]; then
	cd ${CMSSW_DIR}/src
	cmsenv
fi

scram_tag(){
	cd $CMSSW_BASE
	TOOL="$1"
	TAG="$2"
	scram tool tag $TOOL $TAG 2> /dev/null || true
}
export -f scram_tag
