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

scram_tag(){
	cd $CMSSW_BASE
	TOOL="$1"
	TAG="$2"
	scram tool tag $TOOL $TAG 2> /dev/null || true
}
export -f scram_tag

join_path(){
	local IFS=';'
	echo "$*"
}
export -f join_path

for EXTERNAL in ${EXTERNALS[@]}; do
	echo ${EXTERNAL}
	mkdir -p ${CMSSW_BASE}/install/${EXTERNAL}
	${SETUP_DIR}/install/${EXTERNAL}.sh
	update_paths ${INSTALL_DIR}/${EXTERNAL}
done

rm -rf ${CMSSW_BASE}/build
