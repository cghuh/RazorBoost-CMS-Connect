#!/bin/bash

sandbox=$1
joblist=$2
region=$3

if [ $region == "EU" ]; then
    sed "s;SANDBOX;$sandbox;;s;JOBLIST;$joblist;" condor/condor_task_template_EU.cfg  > tmp.cfg
elif [ $region == "US" ]; then
    sed "s;SANDBOX;$sandbox;;s;JOBLIST;$joblist;" condor/condor_task_template_US.cfg  > tmp.cfg
fi
condor_submit tmp.cfg
rm tmp.cfg
