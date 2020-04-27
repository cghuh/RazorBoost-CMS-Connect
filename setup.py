import os, re, sys, glob, socket, subprocess, ROOT

ANA_BASE = os.environ['CMSSW_BASE']+'/src/BoostAnalyzer17'
if 'grid18.kfki.hu' in socket.gethostname(): ANA_BASE='/data/jkarancs/CMSSW/BoostAnalyzer17'
vf = ["condor/filelist_2016.txt", "condor/filelist_2017.txt", "condor/filelist_2018.txt"]

print "Creating file lists ... "
if not os.path.exists(ANA_BASE+'/filelists/2016/data'):        os.makedirs(ANA_BASE+'/filelists/2016/data')
if not os.path.exists(ANA_BASE+'/filelists/2016/signals'):     os.makedirs(ANA_BASE+'/filelists/2016/signals')
if not os.path.exists(ANA_BASE+'/filelists/2016/backgrounds'): os.makedirs(ANA_BASE+'/filelists/2016/backgrounds')
if not os.path.exists(ANA_BASE+'/filelists/2017/data'):        os.makedirs(ANA_BASE+'/filelists/2017/data')
if not os.path.exists(ANA_BASE+'/filelists/2017/signals'):     os.makedirs(ANA_BASE+'/filelists/2017/signals')
if not os.path.exists(ANA_BASE+'/filelists/2017/backgrounds'): os.makedirs(ANA_BASE+'/filelists/2017/backgrounds')
if not os.path.exists(ANA_BASE+'/filelists/2018/data'):        os.makedirs(ANA_BASE+'/filelists/2018/data')
if not os.path.exists(ANA_BASE+'/filelists/2018/signals'):     os.makedirs(ANA_BASE+'/filelists/2018/signals')
if not os.path.exists(ANA_BASE+'/filelists/2018/backgrounds'): os.makedirs(ANA_BASE+'/filelists/2018/backgrounds')
for txtfile in glob.glob(ANA_BASE+'/filelists/*/*/*.txt'):
    os.remove(txtfile)

for flist in vf:
    # Decide year
    year = '2016'
    if '2017' in flist:
        year = '2017'
    elif '2018' in flist:
        year = '2018'
    with open(flist) as filelist:
        for line in filelist:
            filename = line.split()[0]
            sample = ""
            # don't forget also tnm.cc
            for i in range(2,len(filename.split("/"))+1):
                subdir = filename.split("/")[-i]
                if len(subdir):
                    if sample == "" and not subdir[0].isdigit():
                        if not subdir.startswith("PU") and not subdir.startswith("NANOAOD"):
                            sample = subdir
            # Data
            if re.compile('.*20[1-2][0-9][A-J].*').match(sample):
                flist = open(ANA_BASE+'/filelists/'+year+'/data/'+sample+'.txt', 'a')
                print>>flist, filename
            # Signals
            elif re.compile('.*T[1-9][t,b,c,q,W,Z,H][t,b,c,q,W,Z,H].*').match(sample) or "TChi" in sample:
                flist = open(ANA_BASE+'/filelists/'+year+'/signals/'+sample+'.txt', 'a')
                print>>flist, filename
            # Backgrounds
            else:
                flist = open(ANA_BASE+'/filelists/'+year+'/backgrounds/'+sample+'.txt', 'a')
                print>>flist, filename
print 'Done.'

print "Creating an input event number txt file ... "

bad_files = open("bad_files_found.txt", "w")
if os.path.exists("condor/filelist_and_counts.txt"):
    os.remove("condor/filelist_and_counts.txt")
for flist in vf:
    countsfile = open("condor/filelist_and_counts_test.txt", 'a')
    with open(flist) as filelist:
        for line in filelist:
            filename = line.split()[0]
            fin = ROOT.TFile.Open(filename)
            if not fin:
                print filename+" is not a root file"
                print>>bad_files, filename+" bad file"
            else:
                tree = fin.Get("Events")
                if tree:
                    if tree.GetEntries()>0:
                        print>>countsfile, filename+" "+str(tree.GetEntries())
                    else:
                        print filename+" has 0 entries"
                        print>>bad_files, filename+" 0 entry"
                else:
                        print filename+" has no tree"
                        print>>bad_files, filename+" no tree"


print "Creating temp file list directories (for batch and split jobs) ... "

if not os.path.exists(ANA_BASE+'/filelists_tmp/2016/data'):        os.makedirs(ANA_BASE+'/filelists_tmp/2016/data')
if not os.path.exists(ANA_BASE+'/filelists_tmp/2016/signals'):     os.makedirs(ANA_BASE+'/filelists_tmp/2016/signals')
if not os.path.exists(ANA_BASE+'/filelists_tmp/2016/backgrounds'): os.makedirs(ANA_BASE+'/filelists_tmp/2016/backgrounds')
if not os.path.exists(ANA_BASE+'/filelists_tmp/2017/data'):        os.makedirs(ANA_BASE+'/filelists_tmp/2017/data')
if not os.path.exists(ANA_BASE+'/filelists_tmp/2017/signals'):     os.makedirs(ANA_BASE+'/filelists_tmp/2017/signals')
if not os.path.exists(ANA_BASE+'/filelists_tmp/2017/backgrounds'): os.makedirs(ANA_BASE+'/filelists_tmp/2017/backgrounds')
if not os.path.exists(ANA_BASE+'/filelists_tmp/2018/data'):        os.makedirs(ANA_BASE+'/filelists_tmp/2018/data')
if not os.path.exists(ANA_BASE+'/filelists_tmp/2018/signals'):     os.makedirs(ANA_BASE+'/filelists_tmp/2018/signals')
if not os.path.exists(ANA_BASE+'/filelists_tmp/2018/backgrounds'): os.makedirs(ANA_BASE+'/filelists_tmp/2018/backgrounds')

print 'Done.'
