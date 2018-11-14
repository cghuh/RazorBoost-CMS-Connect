# RazorBoost-CMS-Connect

This is CMS connect scripts for 2017's CMS razor boost analysis. It is not fully automatically. I'll update them soon.

## How to run
	* tar -cjf sandbox-CMSSW_9_4_9-b766bc0.tar.bz2 CMSSW_9_4_9  // If you have update about analyis code.
	* condor_submit analysis.submit

## Before you do run
	* If you need, you can use private filelist and need to fix in analysis_submit(#15)
	* you have to make directory under log/ . It must be same name in analysis_submit(#9-11)
	* You have to fix directory_name in runAnalysis.sh(#37) . It should be exist in your cluster(ex. eos)
	* runAnalysis.sh(#76-85) You should fix that directory same as in your storage.
	
# Rerun
	* When you finished to run the script, some are failed. In this situation, you can re-run using MakeRerunList.sh
	* You have to put the log directory location in MakeRerunList.sh(#3)
	* source MakeRerunList.sh
	* You can get a rerun.txt
	* fix the analysis.submit(#13-15); you have to use "Queue channel from rerun.txt"
