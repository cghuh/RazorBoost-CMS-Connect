# RazorBoost-CMS-Connect
CMS-connect scripts for Razor Boost analysis 2017/2018. It should be more develope. Filelist.txt is skimming file location.

## Recipe

```Shell
git clone https://github.com/cghuh/RazorBoost-CMS-Connect
tar -cjf sandbox-CMSSW_9_4_9-b766bc0.tar.bz2 CMSSW_9_4_9
condor_submit analysis.submit
```

## description

### Before running
    You have to bring razor boost analysis scripts and must have to exectue file("Analyzer")
    Fix the "analysis.submit" file, #9-12. This is log file location. You have to made this folder. If you don't the run's are not running.
    Fix the "runAnalysis.sh" file, #37 : This is specific directory that you stored the results. 
    Fix the "runAnalysis.sh" file, #78 : This is site and storage address. You have to fix that you can use.
   
### do running
    condor_submit analysis.submit
    The results are saved in storage that you put in the "runAnalysis.sh".
    The files are saved in each sample directory.
    
### after running (re-run)
    When you run the samples, it cause error. The you can run the "MakeRerunList.sh" scripts. It get a error of running from log files.
    Fix #3 that the log file location.
    * source MakeRerunList.sh
    Then "run.txt" files are created. If it isn't created, all of runs are fine.
    If you get "run.txt", you can fix the "analysis.submit" #13-14 and do submit the condor again.
