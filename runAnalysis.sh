#! /bin/bash

exit_on_error() {
    result=$1
    code=$2
    message=$3

    if [ $1 != 0 ]; then
        echo $3
        exit $2
    fi
} 

#### FRAMEWORK SANDBOX SETUP ####
# Load cmssw_setup function
source cmssw_setup.sh

# Setup CMSSW Base
export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
source $VO_CMS_SW_DIR/cmsset_default.sh
export SCRAM_ARCH=slc6_amd64_gcc630

# Download sandbox
sandbox_name="sandbox-CMSSW_9_4_9-b766bc0.tar.bz2"
#wget --no-check-certificate --progress=bar "http://stash.osgconnect.net/+khurtado/${sandbox_name}" || exit_on_error $? 150 "Could not download sandbox."

# Setup framework from sandbox
#cmssw_setup $sandbox_name || exit_on_error $? 151 "Could not unpack sandbox"
#### END OF FRAMEWORK SANDBOX SETUP ####
tar -xf $sandbox_name

export CMSSW_BASE=CMSSW_9_4_9/

# Name my input channel
channel_rootpath="$1"
channel_name="$(basename $channel_rootpath)"
#directory_name="190115"
#directory_name="190115_PFHT1050"
#directory_name="190115_AK8PFHT800_TrimMass50"
#directory_name="190115_PFHT500_PFMET100_PFMHT100_IDTight"
#directory_name="190115_PFHT1050_AK8PFHT800_TrimMass50"
#directory_name="190115_PFHT1050_PFHT500_PFMET100_PFMHT100_IDTight"
directory_name="190428_PFHT1050_PFHTXXX_PFMETXXX_PFMHTXXX_IDTight"

# Enter script directory
cd $CMSSW_BASE/src/BoostAnalyzer17/
eval `scramv1 runtime -sh`
source setup.sh

#Download ROOTLogon to define plotting styles and load some libraries
#wget --no-check-certificate --progress=bar "http://stash.osgconnect.net/+khurtado/rootlogon.C" || exit_on_error $? 150 "Could not download rootlogon."

#make -Bj;
if [[ "$channel_rootpath" == *"JetHT"* ]];then
        list_name="filelists/data/JetHT.txt"
elif [[ "$channel_rootpath" == *"SingleMuon"* ]];then
        list_name="filelists/data/SingleMuon.txt"
elif [[ "$channel_rootpath" == *"SingleElectron"* ]];then
        list_name="filelists/data/SingleElectron.txt"
elif [[ "$channel_rootpath" == *"HTMHT"* ]];then
        list_name="filelists/data/HTMHT.txt"
elif [[ "$channel_rootpath" == *"MET"* ]];then
        list_name="filelists/data/MET.txt"
elif [[ "$channel_rootpath" == *"SinglePhoton"* ]];then
        list_name="filelists/data/SinglePhoton.txt"
else
        list_name="filelists/backgrounds/run.txt"
fi

echo $channel_rootpath > ${list_name}

if [[ "$channel_rootpath" == *"cern"* ]];then
  filename=$(cut -d'/' -f11 filelists/*/*.txt)
else
  filename=$(cut -d'/' -f9 filelists/*/*.txt)
fi

#echo $channel_rootpath > filelists/data/run.txt

# Execute ROOT script
mydate=$(date +%Y_%m_%d)
./Analyzer ${list_name} run.root || exit_on_error $? 152 "Failed running script with ${channel_rootpath}"
#root -b -q -l addvarstotree.C+"(\"$channel_rootpath/*.root\",\"$channel_name.root\")" || exit_on_error $? 152 "Failed running ROOT script."

echo "Output file size: "
du -hs "run.root"

#mydate=$(date +%Y_%m_%d_%k_%M)
#if [[ "$channel_rootpath" == *"JetHT"* ]];then
	#xrdcp -f "run.root" "root://eosuser.cern.ch//eos/user/c/chuh/RazorBoost/${directory_name}/${filename}/${channel_name}" 2>&1 || exit_on_error $? 153 "Failed to transfer the file ${channel_rootpath}"
	xrdcp -f "run.root" "root://eoscms.cern.ch//eos/cms/store/user/chuh/RazorBoost/${directory_name}/${filename}/${channel_name}" 2>&1 || exit_on_error $? 153 "Failed to transfer the file ${channel_rootpath}"
#xrdcp -f "$channel_name.root" "root://cmseos.fnal.gov:1094//eos/uscms/store/user/kenai/xrootd_test/${channel_name}_${mydate}.root" 2>&1

# Clean up
cd -
rm $sandbox_name
