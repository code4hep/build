#!/bin/bash

export SETUP_DIR=$(readlink -f $(dirname -- "${BASH_SOURCE[0]}"))
export BUILD_DIR=$(readlink -f "$SETUP_DIR"/..)
export CMSSW_VERSION=CMSSW_16_1_0_pre1
export CMSSW_DIR=${BUILD_DIR}/${CMSSW_VERSION}
export C4H_BUILD_CORES=8
