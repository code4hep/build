# CODE4hep build

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
```
where `CMSSW_*` is the presently used CMSSW release being used by Code4Hep.