#!/usr/bin/python
#-----------------------------------------------------------------------
# File    : pyfim.py
# Contents: frequent item set mining in Python
#           (in the current version only with the eclat algorithm)
# Author  : Christian Borgelt
# History : 2013.01.23 file created
#           2013.01.24 closed and maximal item set filtering improved
#           2013.01.25 recursion/output data combined in a list
#           2013.02.09 made compatible with Python 3 (print, range)
#           2017.06.02 bugs in perfect extension processing fixed
#-----------------------------------------------------------------------
from sys  import argv, stderr, maxsize
from math import ceil
from time import time

#-----------------------------------------------------------------------

def report (iset, pexs, supp, data):
    '''Recursively report item sets with the same support.
iset    base item set to report (list of items)
pexs    perfect extensions of the base item set (list of items)
supp    (absolute) support of the item set to report
data    static recursion/output data as a list
        [ target, supp, zmin, zmax, maxx, count [, out] ]'''
    if not pexs:                # if no perfect extensions (left)
        data[5] += 1            # count the reported item set
        if len(data) < 7: return# check for a destination
        n = len(iset)           # check the item set size
        if (n < data[2]) or (n > data[3]): return
        if isinstance(data[6], [].__class__):
            data[6].append((tuple(iset), supp))
        else:                   # report the current item set
            for i in iset: data[6].write(str(i)+' '), 
            data[6].write('('+str(supp)+')\n')
    else:                       # if perfect extensions to process
        report(iset+[pexs[0]], pexs[1:], supp, data)
        report(iset,           pexs[1:], supp, data)

#-----------------------------------------------------------------------

def closed (tracts, elim):
    '''Check for a closed item set.
tracts  list of transactions containing the item set
elim    list of lists of transactions for eliminated items
returns whether the item set is closed'''
    for t in reversed(elim):    # try to find a perfect extension
        if tracts <= t: return False
    return True                 # return whether the item set is closed

#-----------------------------------------------------------------------

def maximal (tracts, elim, supp):
    '''Check for a maximal item set.
tracts  list of transactions containing the item set
elim    list of lists of transactions for eliminated items
supp    minimum support of an item set
returns whether the item set is maximal'''
    for t in reversed(elim):    # try to find a frequent extension
        if sum([w for x,w in tracts & t]) >= supp: return False
    return True                 # return whether the item set is maximal

#-----------------------------------------------------------------------

def recurse (tadb, iset, pexs, elim, data):
    '''Recursive part of the eclat algorithm.
tadb    (conditional) transaction database, in vertical representation,
        as a list of item/transaction information, one per (last) item
        (triples of support, item and transaction set)
iset    item set (prefix of conditional transaction database)
pexs    set of perfect extensions (parent equivalent items)
elim    set of eliminated items (for closed/maximal check)
data    static recursion/output data as a list
        [ target, supp, zmin, zmax, maxx, count [, out] ]'''
    tadb.sort()                 # sort items by (conditional) support
    xelm = []; m = 0            # init. elim. items and max. support
    for k in range(len(tadb)):  # traverse the items/item sets
        s,i,t = tadb[k]         # unpack the item information
        if s > m: m = s         # find maximum extension support
        if data[0] in 'cm' and not closed(t, elim+xelm):
            continue            # check for a perfect extension
        proj = []; xpxs = []    # construct the projection of the
        for r,j,u in tadb[k+1:]:# trans. database to the current item:
            u = u & t           # intersect with subsequent lists
            r = sum([w for x,w in u])
            if   r >= s:       xpxs.append(j)
            elif r >= data[1]: proj.append([r,j,u])
        xpxs = pexs +xpxs       # combine perfect extensions and
        xset = iset +[i]        # add the current item to the set and
        n    = len(xpxs) if data[0] in 'cm' else 0
        r    = recurse(proj, xset, xpxs, elim+xelm, data) \
               if proj and (len(xset)+n < data[4]) else 0
        xelm += [t]             # collect the eliminated items
        if   data[0] == 'm':    # if to report only maximal item sets
            if r < data[1] and maximal(t, elim+xelm[:-1], data[1]):
                report(xset+xpxs, [], s, data)
        elif data[0] == 'c':    # if to report only closed  item sets
            if r < s: report(xset+xpxs, [], s, data)
        else:                   # if to report all frequent item sets
            report(xset, xpxs, s, data)
    return m                    # return the maximum extension support

#-----------------------------------------------------------------------

def eclat (tracts, target='s', supp=2, zmin=1, zmax=maxsize, out=0):
    '''Find frequent item set with the eclat algorithm.
tracts  transaction database to mine (mandatory)
        The database must be a list or a tuple of transactions;
        each transaction must be a list or a tuple of items.
        An item can be any hashable object.
target  type of frequent item sets to find     (default: 's')
        s/a   sets/all   all     frequent item sets
        c     closed     closed  frequent item sets
        m     maximal    maximal frequent item sets
supp    minimum support of an item set         (default: 2)
        (positive: percentage, negative: absolute number)
zmin    minimum number of items per item set   (default: 1)
zmax    maximum number of items per item set   (default: no limit)
out     output file or list as a destination   (default: None)
returns if a parameter 'out' is a list, the return value is a list of
        pairs (i.e. tuples with two elements), each consisting of a
        found frequent item set (as a tuple of items) and this item
        set's (absolute) support, otherwise (if the parameter 'out'
        is not a list) the number of found (frequent) item sets.'''
    supp = -supp if supp < 0 else int(ceil(0.01*supp*len(tracts)))
    if supp <= 0: supp = 1      # check and adapt the minimum support
    if zmax <  0: zmax = maxsize# and the maximum item set size
    if len(tracts) < supp:      # check whether any set can be frequent
        return out if isinstance(out, [].__class__) else 0
    tadb = dict()               # reduce by combining equal transactions
    for t in [frozenset(t) for t in tracts]:
        if t in tadb: tadb[t] += 1
        else:         tadb[t]  = 1
    tracts = tadb.items()       # get reduced trans. and collect items
    items  = set().union(*[t for t,w in tracts])
    tadb   = dict([(i,[]) for i in items])
    for t in tracts:            # collect transactions per item
        for i in t[0]: tadb[i].append(t)
    tadb = [[sum([w for t,w in tadb[i]]), i, set(tadb[i])]
            for i in tadb]      # build and filter transaction sets
    sall = sum([w for t,w in tracts])
    pexs = [i for s,i,t in tadb if s >= sall]
    tadb = [t for t in tadb if t[0] >= supp and t[0] < sall]
    maxx = zmax+1 if zmax < maxsize and target in 'cm' else zmax
    data = [target, supp, zmin, zmax, maxx, 0]
    if not isinstance(out, (0).__class__): data.append(out)
    r = recurse(tadb, [], pexs, [], data)
    if len(pexs) >= zmin:       # recursively find frequent item sets
        if   target == 'm':     # if to report only maximal item sets
            if r < supp: report(pexs, [], sall, data)
        elif target == 'c':     # if to report only closed  item sets
            if r < s:    report(pexs, [], sall, data)
        else:                   # if to report all frequent item sets
            report([], pexs, sall, data)  # report the empty item set
    if isinstance(out, [].__class__): return out
    return data[5]              # return (number of) found item sets

#-----------------------------------------------------------------------

def fim (tracts, target='s', supp=2, zmin=1, zmax=maxsize):
    '''Find frequent item set with the eclat algorithm.
tracts  transaction database to mine (mandatory)
        The database must be a list or a tuple of transactions;
        each transaction must be a list or a tuple of items.
        An item can be any hashable object.
target  type of frequent item sets to find     (default: 's')
        s/a   sets/all   all     frequent item sets
        c     closed     closed  frequent item sets
        m     maximal    maximal frequent item sets
supp    minimum support of an item set         (default: 2)
        (positive: percentage, negative: absolute number)
zmin    minimum number of items per item set   (default: 1)
zmax    maximum number of items per item set   (default: no limit)
returns returns a list of pairs (i.e. tuples with two elements),
        each consisting of a found frequent item set (as a tuple of
        items) and this item set's (absolute) support.'''
    return eclat(tracts, target, supp, zmin, zmax, [])

#-----------------------------------------------------------------------

if __name__ == '__main__':
    desc    = 'find frequent item sets (with the eclat algorithm)'
    version = 'version 1.3 (2017.06.02)         ' \
            + '(c) 2013-2017   Christian Borgelt'
    opts    = {'t': ['target', 's'],
               'm': ['zmin',    1 ],
               'n': ['zmax',   -1 ],
               's': ['supp',   10 ] }
    fixed   = []                # list of program options

    if len(argv) <= 1:          # if no arguments are given
        opts = dict([(o,opts[o][1]) for o in opts])
        print('usage: pyfim.py [options] infile [outfile]')
        print(desc); print(version)
        print('-t#      target type                            '
                      +'(default: '+str(opts['t'])+')')
        print('         (s: frequent, c: closed, m: maximal item sets)')
        print('-m#      minimum number of items per item set   '
                      +'(default: '  +str(opts['m'])+')')
        print('-n#      maximum number of items per item set   '
                      +'(default: no limit)')
        print('-s#      minimum support                        '
                      +'(default: '  +str(opts['s'])+'%)')
        print('         (positive: percentage, '
                      +'negative: absolute number)')
        print('infile   file to read transactions from         '
                      +'[required]')
        print('outfile  file to write frequent item sets to    '
                      +'[optional]')
        exit()                  # print a usage message

    stderr.write('pyfim.py')    # print a startup message
    stderr.write(' - ' +desc +'\n' +version +'\n')

    for a in argv[1:]:          # traverse the program arguments
        if a[0] != '-':         # check for a fixed argument
            if len(fixed) < 2: fixed.append(a); continue
            else: print('too many fixed arguments'); exit()
        if a[1] not in opts:    # check for an option
            print('unknown option: '+a[:2]); exit()
        o = opts[a[1]]          # get the corresponding option
        v = a[2:]               # and get the option argument
        if   isinstance(o[1],(0).__class__): o[1] = int(v)
        elif isinstance(o[1],0.0.__class__): o[1] = float(v)
        else:                                o[1] = v
    opts = dict([opts[o] for o in opts])

    t = time()                  # read the transaction data
    stderr.write('reading ' +fixed[0] +' ... ')
    with open(fixed[0], 'rt') as inp:
        tracts = [frozenset(line.split()) for line in inp]
    n = len(tracts)             # get the number of transactions
    stderr.write('[%d transaction(s)] ' % n)
    stderr.write('done [%.2fs].\n' % (time()-t))

    t = time()                  # mine frequent item sets
    stderr.write('mining frequent item sets ... ')
    if len(fixed) < 2:          # if no output file is given
        n = eclat(tracts, **opts)
    else:                       # if an output file is given
        with open(fixed[1], 'w') as out:
            n = eclat(tracts, out=out, **opts)
    stderr.write('[%d sets(s)] ' % n)
    stderr.write('done [%.2fs].\n' % (time()-t))
