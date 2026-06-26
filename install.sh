#!/bin/bash

EXTERNALS=(
cmake \
podio \
edm4hep \
lcio \
k4geo \
geant4 \
)

for EXTERNAL in ${EXTERNALS[@]}; do
	echo ${EXTERNAL}
	mkdir -p ${CMSSW_BASE}/install/${EXTERNAL}
	${SETUP_DIR}/install/${EXTERNAL}.sh
	# refresh env after tool installation
	cmsenv
done

rm -rf ${CMSSW_BASE}/build
