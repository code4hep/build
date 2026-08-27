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

remove_from_path(){
	PATH_VAR="$1"
	PATH_REM="$2"
	PATH_CURR="${!PATH_VAR}"
	PATH_NEW=$(echo "$PATH_CURR" | tr ':' '\n' | grep -v -x "$PATH_REM" | paste -sd:)
	export "$PATH_VAR"="$PATH_NEW"
}

remove_from_paths(){
	# only use CMSSW for externals
	# avoid conflicts from local libraries
	for BASE_VAR in CMSSW_BASE CMSSW_RELEASE_BASE; do
		remove_from_path PATH "${!BASE_VAR}/bin/${SCRAM_ARCH}"
		remove_from_path LD_LIBRARY_PATH "${!BASE_VAR}/lib/${SCRAM_ARCH}"
		remove_from_path LD_LIBRARY_PATH "${!BASE_VAR}/biglib/${SCRAM_ARCH}"
		remove_from_path PYTHON3PATH "${!BASE_VAR}/python"
		remove_from_path PYTHON3PATH "${!BASE_VAR}/lib/${SCRAM_ARCH}"
	done
}

update_paths(){
	EXT_BASE="$1"
	EXT_BASE="${EXT_BASE%/}"
	EXT_BIN="$EXT_BASE"/bin
	if [ -d "$EXT_BIN" ]; then
		export PATH=${EXT_BIN}:${PATH}
	fi
	EXT_LIB="$EXT_BASE"/lib
	if [ -d "$EXT_LIB" ]; then
		export LD_LIBRARY_PATH=${EXT_LIB}:${LD_LIBRARY_PATH}
	fi
	EXT_LIB64="$EXT_BASE"/lib64
	if [ -d "$EXT_LIB64" ]; then
		export LD_LIBRARY_PATH=${EXT_LIB64}:${LD_LIBRARY_PATH}
	fi
	PYVER=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
	EXT_PY="$EXT_BASE"/lib/python${PYVER}/site-packages
	if [ -d "$EXT_PY" ]; then
		export PYTHON3PATH=${EXT_PY}:${PYTHON3PATH}
	fi
	EXT_INC="$EXT_BASE"/include
	if [ -d "$EXT_INC" ]; then
		export ROOT_INCLUDE_PATH=${EXT_INC}:${ROOT_INCLUDE_PATH}
	fi
}
export -f update_paths

source common.sh
source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -e "$CMSSW_DIR" ]; then
	pushd ${CMSSW_DIR}/src && cmsenv && popd
	remove_from_paths
fi
if [ -d "$INSTALL_DIR" ]; then
	for EXT in "$INSTALL_DIR"/*/; do
		EXTNAME=$(basename $EXT)
		if [ "$EXTNAME" = "stitched" ]; then
			source "$INSTALL_DIR/stitched/bin/stitched_env.sh"
			# CMSSW uses PYTHON3PATH rather than PYTHONPATH
			export PYTHON3PATH=${PYTHONPATH}:${PYTHON3PATH}
		else
			update_paths "$EXT"
		fi
	done
fi
