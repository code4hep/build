#!/bin/tcsh
set sourced=($_)
set scriptdir = `dirname "$sourced[2]"`

# automatically source init.sh and export its environment changes in tcsh form

eval `$scriptdir/init_to_tcsh.sh`
