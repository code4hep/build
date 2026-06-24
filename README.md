# CODE4hep build

This is an interim branch to bootstrap a CMake-based installation, still using CMSSW dependencies.

## Installation

```bash
mkdir -p scratch
cd scratch
git clone git@github.com:code4hep/build
cd build
./setup.sh
```

To enable debug symbols in all external and CMSSW builds, change the last line:
```bash
./setup.sh -d
```

## Usage

```bash
cd build
source init.sh
```

`init.csh` is provided for `tcsh` users.

At the end, you will have the following directory structure
```
scratch/
   build/
   CMSSW_*/
   install/
   tmp/
```
where `CMSSW_*` is the CMSSW release currently used by Code4Hep.
