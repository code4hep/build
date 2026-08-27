#!/bin/bash

EXTERNALS=(
cmake \
podio \
edm4hep \
geant4 \
lcio \
k4geo \
c4h_md5 \
stitched \
#stitched-example \
code4hep \
)

for EXTERNAL in ${EXTERNALS[@]}; do
	echo ${EXTERNAL}
	mkdir -p ${CMSSW_BASE}/install/${EXTERNAL}
	${SETUP_DIR}/install/${EXTERNAL}.sh
	update_paths ${INSTALL_DIR}/${EXTERNAL}
done

rm -rf ${CMSSW_BASE}/build
