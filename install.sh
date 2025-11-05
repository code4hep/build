#!/bin/bash

BASE_DIR=$(dirname -- "${BASH_SOURCE[0]}")

export C4H_BUILD_CORES=8

EXTERNALS=(
cmake \
podio \
edm4hep \
)

for EXTERNAL in ${EXTERNALS[@]}; do
	echo $(basename ${EXTERNAL})
	${BASE_DIR}/install/${EXTERNAL}.sh
done
