import os, re, sys, glob, socket, subprocess, ROOT

ANA_BASE = os.environ['CMSSW_BASE']+'/src/BoostAnalyzer17'
if 'grid18.kfki.hu' in socket.gethostname(): ANA_BASE='/data/jkarancs/CMSSW/BoostAnalyzer17'

print "Creating file lists ... ",
if not os.path.exists(ANA_BASE+'/filelists/data'): os.makedirs(ANA_BASE+'/filelists/data')
if not os.path.exists(ANA_BASE+'/filelists/signals'): os.makedirs(ANA_BASE+'/filelists/signals')
if not os.path.exists(ANA_BASE+'/filelists/backgrounds'): os.makedirs(ANA_BASE+'/filelists/backgrounds')
for txtfile in glob.glob(ANA_BASE+'/filelists/*/*.txt'):
    os.remove(txtfile)

with open("condor/filelist.txt") as filelist:
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
            flist = open(ANA_BASE+'/filelists/data/'+sample+'.txt', 'a')
            print>>flist, filename
        # Signals
        elif re.compile('.*T[1-9][t,b,c,q,W,Z,H][t,b,c,q,W,Z,H].*').match(sample) or "TChi" in sample:
            flist = open(ANA_BASE+'/filelists/signals/'+sample+'.txt', 'a')
            print>>flist, filename
        # Backgrounds
        else:
            flist = open(ANA_BASE+'/filelists/backgrounds/'+sample+'.txt', 'a')
            print>>flist, filename
print 'Done.'

print "Creating an input event number txt file ... ",
bad_files = open("bad_files_found.txt", "w")
with open("condor/filelist.txt") as filelist:
    if os.path.exists("condor/filelist_and_counts.txt"):
        os.remove("condor/filelist_and_counts.txt")
    countsfile = open("condor/filelist_and_counts.txt", 'a')
    for line in filelist:
        filename = line.split()[0]
        fin = ROOT.TFile.Open(filename)
        if not fin:
            print filename+" is not a root file"
            print>>bad_files, filename+" bad file"
        else:
            tree = fin.Get("Events")
            if tree.GetEntries()>0:
                print>>countsfile, filename+" "+str(tree.GetEntries())
            else:
                print filename+" has 0 entries"
                print>>bad_files, filename+" 0 entry"

print "Creating temp file list directories (for batch and split jobs) ... ",
if not os.path.exists(ANA_BASE+'/filelists_tmp/data'): os.makedirs(ANA_BASE+'/filelists_tmp/data')
if not os.path.exists(ANA_BASE+'/filelists_tmp/signals'): os.makedirs(ANA_BASE+'/filelists_tmp/signals')
if not os.path.exists(ANA_BASE+'/filelists_tmp/backgrounds'): os.makedirs(ANA_BASE+'/filelists_tmp/backgrounds')

print 'Done.'
