source common.csh
source /cvmfs/cms.cern.ch/cmsset_default.csh
if ( -d "$CMSSW_DIR" ) then
	cd ${CMSSW_DIR}/src
	cmsenv
endif
