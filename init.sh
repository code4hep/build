#!/bin/bash

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

update_paths(){
	EXT_BASE="$1"
	EXT_BASE="${EXT_BASE%/}"
	EXT_BIN="$EXT_BASE"/bin
	if [ -d "$EXT_BIN" ]; then
		export PATH=$PATH:$EXT_BIN
	fi
	EXT_LIB="$EXT_BASE"/lib
	if [ -d "$EXT_LIB" ]; then
		export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$EXT_LIB
	fi
	EXT_LIB64="$EXT_BASE"/lib64
	if [ -d "$EXT_LIB64" ]; then
		export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$EXT_LIB64
	fi
	PYVER=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
	EXT_PY="$EXT_BASE"/lib/python${PYVER}/site-packages
	if [ -d "$EXT_PY" ]; then
		export PYTHON3PATH=$PYTHON3PATH:$EXT_PY
	fi
	EXT_INC="$EXT_BASE"/include
	if [ -d "$EXT_INC" ]; then
		export ROOT_INCLUDE_PATH=$ROOT_INCLUDE_PATH:$EXT_INC
	fi
}
export -f update_paths

source common.sh
source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -e "$CMSSW_DIR" ]; then
	pushd ${CMSSW_DIR}/src && cmsenv && popd
fi
if [ -d "$INSTALL_DIR" ]; then
	for EXT in "$INSTALL_DIR"/*/; do
		if [ "$EXT" = "stitched" ]; then
			source "$INSTALL_DIR/stitched/bin/stitched_env.sh"
		else
			update_paths "$EXT"
		fi
	done
fi
