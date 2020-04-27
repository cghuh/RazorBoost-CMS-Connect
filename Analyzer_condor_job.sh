#!/bin/bash
echo   "UnixTime-JobStart: "$(date +%s)

arch=slc7_amd64_gcc700
rel=CMSSW_10_2_18
sandbox=$(ls sandbox*.tar.bz2)
arguments=${@:1}
cwd=$(pwd)

echo -e "------------------- START --------------------"
printf "Start time: "; TZ=CET /bin/date
printf "Job is running on node: "; /bin/hostname
printf "Job running as user: "; /usr/bin/id
printf "Job is running in directory: "; /bin/pwd -P
echo
echo -e "---------------- Environments ----------------"

echo -e "\n[0] source /cvmfs/cms.cern.ch/cmsset_default.sh"
source /cvmfs/cms.cern.ch/cmsset_default.sh

echo -e "\n[1] export SCRAM_ARCH=$arch"
export SCRAM_ARCH=$arch

echo -e "\n[2] scramv1 project CMSSW $rel"
scramv1 project CMSSW $rel

echo -e "\n[3] tar -xjf $sandbox -C $rel/src/"
tar -xjf $sandbox -C $rel/src/

echo -e "\n[4] cd $rel/src/BoostAnalyzer17"
cd $rel/src/BoostAnalyzer17

echo -e "\n[5] cmsenv"
eval `scramv1 runtime -sh`

echo -e "\n[6] source setup.sh"
source setup.sh

echo -e "\n------------------ Analyzer ------------------"

echo   "UnixTime-AnalyzerStart: "$(date +%s)

echo -e "\n[7] time ./Analyzer $cwd/output.root $arguments 2>&1"
time ./Analyzer $cwd/output.root $arguments 2>&1


echo   "UnixTime-AnalyzerEnd: "$(date +%s)

echo -e "\n------------------ Cleanup -------------------"

echo -e "\n[8] cd -"
cd -

echo -e "\n[9] rm -r $rel"
rm -r $rel

echo -e "\n[10] ls -ltr"
ls -ltr

# delete output file if too small
# This prevents late, parallel and failing condor jobs overwriting the otherwise good output
if [ -f output.root ]; then 
    if [ $(ls -l output.root | awk '{ print $5 }' ) -lt 1000 ]; then 
        echo -e "\n[11] rm output.root"
        rm output.root
    fi
fi

echo -e "\n"
echo -e "-------------------- END ---------------------\n"
echo   "UnixTime-JobEnd: "$(date +%s)
