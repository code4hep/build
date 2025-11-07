#!/bin/tcsh
set sourced=($_)
set scriptdir = `dirname "$sourced[2]"`

# automatically source common.sh and export its variables in tcsh form

eval `$scriptdir/common_to_tcsh.sh`
