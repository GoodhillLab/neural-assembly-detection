#!/usr/bin/python
#-----------------------------------------------------------------------
# File    : patspec.py
# Contents: pattern spectrum functions
# Author  : Christian Borgelt
# History : 2013.12.03 file created
#           2013.12.06 function psp2bdr added, pspfilter adapted
#           2013.12.14 fixed a problem with Python3 in psp2bdr()
#           2013.05.12 psp2bdr/pspfilter() changed to support thresholds
#           2014.05.20 range check added to function pspfilter()
#           2014.06.10 parameter supp added to function psp2bdr()
#           2014.10.11 argument order for patspec() changed
#           2015.08.13 function patspec() renamed to genpsp()
#-----------------------------------------------------------------------
from sys             import argv, stderr, path
from os.path         import join
from random          import seed as srand
from time            import time
from math            import floor, ceil
from multiprocessing import Process, Queue, Value, cpu_count
NEURODIR = join('..', 'neuro')
if NEURODIR not in path: path.insert(0, NEURODIR)
from surrogates      import getrandfn, getsurrfn
try:
    from coco    import coconad
except ImportError:
    COCODIR = join('..', 'coconad')
    if COCODIR not in path: path.insert(0, COCODIR)
    from coconad import coconad

#-----------------------------------------------------------------------
# Constants
#-----------------------------------------------------------------------
oo = float('inf')               # positive infinity as a constant

#-----------------------------------------------------------------------
# Functions
#-----------------------------------------------------------------------

def psproc (trains, surrfn, randfn, beg, end, delta,
            target, supp, width, zmin, zmax, seed,
            cnt, queue, done):
    '''psproc (trains, surrfn, randfn, beg, end, delta
        target, supp, width, zmin, zmax, cnt, queue, done)
Function for multiprocessing pattern spectrum generation.
trains  a list of pairs consisting of an item id and a list of points
surrfn  a function to generate a surrogate data set from trains
randfn  a function for random numbers (symmetric with mode 0)
beg     beginning of points (to clamp displaced points/spikes)
end     end       of points (to clamp displaced points/spikes)
delta   block size for blocked point/spike permutations
target  target for CoCoNAD algorithm (e.g. 'c' for closed item sets)
supp    minimum support for CoCoNAD algorithm
width   width of time window/maximum distance for CoCoNAD algorithm
zmin    minimum size of an item set for CoCoNAD algorithm
zmax    maximum size of an item set for CoCoNAD algorithm
seed    seed for random number generator
cnt     number of surrogate data set to generate
queue   for returning the generated patten spectrum
done    for communicating the number of already generated data sets
The generated pattern spectrum is returned through the queue.'''
    srand(seed)                 # seed random number generator
    psp = dict()                # initialize the pattern spectrum
    for k in range(cnt):        # generate surrogate data sets
        surr = surrfn(trains, randfn, beg, end, delta)
        cps  = coconad(surr, target, width, supp, zmin, zmax, '#')
        for s in cps:           # get pattern spectrum of surrogate
            if s in psp: psp[s] += cps[s]
            else:        psp[s]  = cps[s]
        done.value += 1         # count the generated surrogate
        if done.value % 20 == 0:# print a progress counter
            stderr.write('%10d\b\b\b\b\b\b\b\b\b\b' % done.value)
    queue.put(psp)              # return the pattern spectrum

#-----------------------------------------------------------------------

def genpsp (trains, target='s', supp=2, width=0.003, zmin=2, zmax=None,
            report='#', algo='r', mode='', cnt=1000, beg=-oo, end=oo,
            surr='p', rand='u', sigma=0.005, delta=0.03, seed=0,
            cpus=0):
    '''genpsp (trains, target='c', supp=2, width=0.003, zmin=2, zmax=-1,
         report='#', algo='r', mode='', cnt=1000, beg=-oo, end=oo,
         surr='p', rand='u', sigma=0.005, delta=0.03, seed=0, cpus=0)
Generate a pattern spectrum from surrogate data sets.
trains  (spike) train database to mine         (mandatory)
        The database must be an iterable of (spike) trains;
        each train must be a pair, consisting of a item/neuron
        identifier and an iterable of points/spike times;
        each item/neuron identifier must be a hashable object.
target  type of frequent item sets to find     (default: s)
        s    sets/all   all     frequent item sets
        c    closed     closed  frequent item sets
        m    maximal    maximal frequent item sets
supp    minimum support of an item set         (default: 2)
width   width of time window/influence region  (default: 0.003)
zmin    minimum number of items per item set   (default: 2)
zmax    maximum number of items per item set   (default: no limit)
report  pattern spectrum reporting format      (default: #)
        =    pattern spectrum as a list of triplets
        #    pattern spectrum as a dictionary
algo    algorithm variant to use               (default: r)
        (ignored in Python code, evaluated only in PyCoCo library)
mode    operation mode indicators/flags        (default: None)
        x    do not use perfect extension pruning
        p    do not sort trains by their length
cnt     number of surrogate data sets          (default: 1000)
beg     beginning of range of points           (default: -oo)
end     end       of range of points           (default: +oo)
surr    surrogate data generation method       (default: p)
        i    ident      identity (keep original data)
        r    random     point/spike time randomization
        d    dither     point/spike dithering/displacement
        s    shift      train shifting/dithering
        k    kernest    sampling from a kernel estimate
        p    permute    dithered point/spike permutation
        b    block      dithered blocked point/spike permutations
rand    random function density identifier     (default: u)
        u    uniform    uniform density (= rectangular)
        r    rect       rectangular density (= uniform)
        t    triang     symmetric triangular density
        g    gauss      Gaussian density (= normal)
        n    normal     normal density (= Gaussian)
sigma   random dispersion parameter            (default: 0.005)
        (standard deviation or half the base width of density)
delta   block size for block permutations      (default: 0.03)
seed    seed for random number generator       (default: 0)
        (seed = 0: use system time as a seed)
cpus    number of cpus/threads/processes       (default: 0)
        (cpus = 0: determine number of cores automatically)
returns a pattern spectrum as a dictionary mapping pairs
        (size, support) to the corresponding occurrence counters
        or as a list of triplets (size, support, count)'''
    if   surr in ['ident','identity']:               surr = 'i'
    elif surr in ['random','randomize']:             surr = 'r'
    elif surr in ['dither']:                         surr = 'd'
    elif surr in ['shift']:                          surr = 's'
    elif surr in ['kernel','kernest']:               surr = 'k'
    elif surr in ['permute']:                        surr = 'p'
    if surr not in ['i','r','d','s','k','p']:        surr = 'p'
    if   rand in ['uniform']:                        rand = 'u'
    elif rand in ['rect','rectangle','rectangular']: rand = 'r'
    elif rand in ['triang','triangle','triangular']: rand = 't'
    elif rand in ['gauss','Gauss']:                  rand = 'g'
    elif rand in ['normal']:                         rand = 'n'
    if rand not in ['u','r','t','g','n']:            rand = 'u'
    if surr == 'i': cnt = 1     # adapt the number of data sets
    if seed ==  0: seed = time()# get seed for random numbers
    if beg <= -oo: beg  = floor(min(min(t) for n,t in trains))
    if end >= +oo: end  = ceil (max(max(t) for n,t in trains))
    if cpus <= 0:               # get the number of cpus
        try:                        cpus = cpu_count()
        except NotImplementedError: cpus = 1
    queue = Queue(); done = Value('i', 0)
    c     = int(cnt/4)          # set up process data
    sizes = [c for i in range(cpus-1)] +[cnt-(cpus-1)*c] \
            if c > 0 else [cnt] # construct the argument lists
    pargs = [trains, getsurrfn(surr), lambda: getrandfn(rand)(sigma),
             beg, end, delta, target, supp, width, zmin, zmax]
    pargs = [tuple(pargs +[seed+i, sizes[i], queue, done])
             for i in range(len(sizes))]
    procs = [Process(target=psproc, args=a) for a in pargs]
    for p in procs: p.start()   # start all processes and then
    for p in procs: p.join()    # wait for them to finish
    psp = dict()                # initialize a pattern spectrum
    for p in procs:             # traverse the completed processes
        cps = queue.get()       # get the produced pattern spectra
        for s in cps:           # and aggregate them into one
            if s in psp: psp[s] += cps[s]
            else:        psp[s]  = cps[s]
    norm = 1.0/float(cnt)       # normalize the pattern spectrum
    for s in psp: psp[s] *= norm
    if report != '=': return psp# return the created pattern spectrum
    return sorted([(z,c,psp[z,c]) for z,c in psp])

#-----------------------------------------------------------------------

def pspthresh (patspec, thresh=1e-4):
    '''pspthresh (patspec, thresh=1e-4)
Threshold a pattern spectrum, that is, delete all entries below the
given threshold.
patspec pattern spectrum (pattern signatures considered chance events);
        a dictionary mapping pattern signatures (size, support) to
        occurrence frequencies
thresh  threshold for keeping/deleting entries
returns a reduced pattern spectrum'''
    return dict([(s,f) for s,f in patspec.items() if f >= thresh])

#-----------------------------------------------------------------------

def psp2bdr (patspec):
    '''psp2bdr (patspec)
Find the decision border of a pattern spectrum.
patspec pattern spectrum (pattern signatures considered chance events);
        a dictionary mapping pattern signatures (size, support) to
        occurrence frequencies
returns an array with the minimum support thresholds per size
        (maximum support +1 in pattern spectrum per size)'''
    if not isinstance(patspec, dict().__class__):
        patspec = [(z,c) for z,c,n in patspec]
    n      = max([z for z,c in patspec]+[0])
    border = list(range(n+1)); m = -1
    for z in reversed(border):  # determine the detection border
        m = max([c for a,c in patspec if a == z]+[m])
        border[z] = m+1         # (support thresholds per size)
    border[0:2] = [oo,oo]       # entirely rule out sizes 0 and 1
    return border               # return the created border

#-----------------------------------------------------------------------

def pspfilter (pats, border):
    '''pspfilter (pats, border)
Perform pattern spectrum filtering.
pats    set of patterns to reduced (already filtered with patspec);
        an iterable of pairs (item set, support), with each item set
        a iterable of items; each item must be a hashable object
border  detection border as a list of support thresholds per size
returns a filtered set of patterns'''
    return [(p,c) for p,c in pats if len(p) >= len(border)
                                  or c >= border[len(p)]]

#-----------------------------------------------------------------------

def pspread (fname):
    '''pspread (fname)
Read a pattern spectrum from a file.
fname   name of the file to read from
returns the read pattern spectrum as a dictionary mapping
        (size, support) pairs (i.e. pattern signatures) to
        occurrence frequencies'''
    patspec = dict()            # initialize a pattern spectrum
    with open(fname, 'r') as inp:
        for line in inp:        # read pattern spectrum from file
            z,c,n = line.split()
            patspec[int(z),int(c)] = float(n)
    return patspec              # return the read pattern spectrum

#-----------------------------------------------------------------------

def pspwrite (patspec, fname, sep=' '):
    '''pspwrite (patspec, fname, sep=' ')
Write a pattern spectrum to a file.
patspec the pattern spectrum to write as a dictionary mapping
        (size, support) pairs (i.e. pattern signatures) to
        occurrence frequencies
fname   name of the file to write to
sep     column separator (default: space)'''
    with open(fname, 'w') as out:
        for s in sorted([(z,c,patspec[z,c]) for z,c in patspec]):
            out.write(('%d'+sep+'%d'+sep+'%.16g\n') % s)

#-----------------------------------------------------------------------

if __name__ == '__main__':
    psp = pspread(argv[1])
    bdr = psp2bdr(psp)
    bdr = [(i,bdr[i]) for i in range(len(bdr))]
    print(bdr)
