#!/bin/bash

EXTERNALS=(
#cmake \
podio \
edm4hep \
lcio \
k4geo \
c4h_md5 \
stitched \
code4hep \
)

for EXTERNAL in ${EXTERNALS[@]}; do
	echo ${EXTERNAL}
	mkdir -p ${CMSSW_BASE}/install/${EXTERNAL}
	${SETUP_DIR}/install/${EXTERNAL}.sh
done

rm -rf ${CMSSW_BASE}/build
