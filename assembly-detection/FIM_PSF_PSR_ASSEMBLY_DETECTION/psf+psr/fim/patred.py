#!/usr/bin/python
#-----------------------------------------------------------------------
# File    : patred.py
# Contents: pattern set reduction functions
# Author  : Christian Borgelt
# History : 2013.01.11 file created from dectred.py
#           2013.01.12 flag setting simplified, redfn0 added
#           2013.01.15 tuned conditions for fewer excess neurons
#           2013.02.27 added second version with excess coincidences
#           2013.02.28 added reduction with number of covered spikes
#           2013.03.01 added computing all add. pair intersections
#           2013.05.25 added pattern set reduction function 8 and 9
#           2013.12.06 filtering changed to detection border
#           2014.06.08 bug in function red_leni0() fixed (s[iA/iB])
#           2014.06.10 border changed to minimum support thresholds
#           2014.07.01 range check for detection border added
#           2014.11.07 bug in red_items2() fixed (iA,iB exchanged)
#           2015.08.12 redesigned with pattern comparison functions
#-----------------------------------------------------------------------
from bisect import bisect_left

#-----------------------------------------------------------------------

def red_none (zA, cA, zB, cB, border):
    '''red_none (zA, cA, zB, cB, border)
Establish no preference, always return 0.
zA      size    of pattern A (number of items)
cA      support of pattern A (number of coincidences)
zB      size    of pattern B (number of items)
cB      support of pattern B (number of coincidences)
border  detection border as a list of minimum support values per size
returns +1 if pattern A is preferred, -1 if pattern B is preferred,
        and 0 if neither pattern is preferred to the other'''
    return 0                    # never prefer any pattern

#-----------------------------------------------------------------------

def red_coins0 (zA, cA, zB, cB, border):
    '''red_coin0 (zA, cA, zB, cB, border)
Reduce with excess coincidences: filter with signature (zB,cB-cA).
zA      size    of pattern A (number of items)
cA      support of pattern A (number of coincidences)
zB      size    of pattern B (number of items)
cB      support of pattern B (number of coincidences)
border  detection border as a list of minimum support values per size
returns +1 if pattern A is preferred, -1 if pattern B is preferred,
        and 0 if neither pattern is preferred to the other'''
    if cA >= cB: return +1      # same support: prefer superset
    return +1 if cB -cA < border[zB] else -1

#-----------------------------------------------------------------------

def red_coins1 (zA, cA, zB, cB, border):
    '''red_coin1 (zA, cA, zB, cB, border)
Reduce with excess coincidences: filter with signature (zB,cB-cA+1)
zA      size    of pattern A (number of items)
cA      support of pattern A (number of coincidences)
zB      size    of pattern B (number of items)
cB      support of pattern B (number of coincidences)
border  detection border as a list of minimum support values per size
returns +1 if pattern A is preferred, -1 if pattern B is preferred,
        and 0 if neither pattern is preferred to the other'''
    if cA >= cB: return +1      # same support: prefer superset
    return +1 if cB -cA +1 < border[zB] else -1

#-----------------------------------------------------------------------

def red_items2 (zA, cA, zB, cB, border):
    '''red_items2 (zA, cA, zB, cB, border)
Reduce with excess items/neurons: filter with signature (zA-zB+2,cA)
zA      size    of pattern A (number of items)
cA      support of pattern A (number of coincidences)
zB      size    of pattern B (number of items)
cB      support of pattern B (number of coincidences)
border  detection border as a list of minimum support values per size
returns +1 if pattern A is preferred, -1 if pattern B is preferred,
        and 0 if neither pattern is preferred to the other'''
    if cA >= cB: return +1      # same support: prefer superset
    return -1 if cA < border[zA -zB +2] else +1

#-----------------------------------------------------------------------

def red_cover0 (zA, cA, zB, cB, border):
    '''red_cover0 (zA, cA, zB, cB, border)
Reduce with number of covered spikes: zA*cA versus zB*cB.
zA      size    of pattern A (number of items)
cA      support of pattern A (number of coincidences)
zB      size    of pattern B (number of items)
cB      support of pattern B (number of coincidences)
border  detection border as a list of minimum support values per size
returns +1 if pattern A is preferred, -1 if pattern B is preferred,
        and 0 if neither pattern is preferred to the other'''
    if cA >= cB: return +1      # same support: prefer superset
    return +1 if zA*cA >= zB*cB else -1

#-----------------------------------------------------------------------

def red_cover1 (zA, cA, zB, cB, border):
    '''red_cover1 (zA, cA, zB, cB, border)
Reduce with number of covered spikes: (zA-1)*cA versus (zB-1)*cB.
zA      size    of pattern A (number of items)
cA      support of pattern A (number of coincidences)
zB      size    of pattern B (number of items)
cB      support of pattern B (number of coincidences)
border  detection border as a list of minimum support values per size
returns +1 if pattern A is preferred, -1 if pattern B is preferred,
        and 0 if neither pattern is preferred to the other'''
    if cA >= cB: return +1      # same support: prefer superset
    return +1 if (zA-1)*cA >= (zB-1)*cB else -1

#-----------------------------------------------------------------------

def red_leni0 (zA, cA, zB, cB, border):
    '''red_leni0 (zA, cA, zB, cB, border)
Reduce with excess coincidences : filter with signature (zB,cB-cA+1)
and    with excess items/neurons: filter with signature (zA-zB+2,cA)
and number of covered points/spikes: zA*cA versus zB*cB.
Keep both if neither excess coincidences nor excess items reject.
zA      size    of pattern A (number of items)
cA      support of pattern A (number of coincidences)
zB      size    of pattern B (number of items)
cB      support of pattern B (number of coincidences)
border  detection border as a list of minimum support values per size
returns +1 if pattern A is preferred, -1 if pattern B is preferred,
        and 0 if neither pattern is preferred to the other'''
    if cA >= cB: return +1      # same support: prefer superset
    xA = cA < border[zA-zB+2]   # excess items  explainable
    xB = cB-cA+1 < border[zB]   # excess coins. explainable
    if     xA and not xB: return -1
    if not xA and     xB: return +1
    if not xA and not xB: return  0
    return +1 if zA*cA >= zB*cB else -1

#-----------------------------------------------------------------------

def red_leni1 (zA, cA, zB, cB, border):
    '''red_leni1 (zA, cA, zB, cB, border)
Reduce with excess coincidences : filter with signature (zB,cB-cA+1)
and    with excess items/neurons: filter with signature (zA-zB+2,cA)
and number of covered points/spikes: (zA-1)*cA versus (zB-1)*cB.
Keep both if neither excess coincidences nor excess items reject.
zA      size    of pattern A (number of items)
cA      support of pattern A (number of coincidences)
zB      size    of pattern B (number of items)
cB      support of pattern B (number of coincidences)
border  detection border as a list of minimum support values per size
returns +1 if pattern A is preferred, -1 if pattern B is preferred,
        and 0 if neither pattern is preferred to the other'''
    if cA >= cB: return +1      # same support: prefer superset 
    xA = cA < border[zA-zB+2]   # excess items  explainable
    xB = cB-cA+1 < border[zB]   # excess coins. explainable
    if     xA and not xB: return -1
    if not xA and     xB: return +1
    if not xA and not xB: return  0
    return +1 if (zA-1)*cA >= (zB-1)*cB else -1

#-----------------------------------------------------------------------

def red_strict0 (zA, cA, zB, cB, border):
    '''red_strict0 (pats, border)
Reduce with excess coincidences : filter with signature (zB,cB-cA+1)
and    with excess items/neurons: filter with signature (zA-zB+2,cA)
and number of covered points/spikes: zA*cA versus zB*cB.
Use number of covered points/spikes to break ties.
zA      size    of pattern A (number of items)
cA      support of pattern A (number of coincidences)
zB      size    of pattern B (number of items)
cB      support of pattern B (number of coincidences)
border  detection border as a list of minimum support values per size
returns +1 if pattern A is preferred, -1 if pattern B is preferred,
        and 0 if neither pattern is preferred to the other'''
    if cA >= cB: return +1      # same support: prefer superset
    xA = cA < border[zA-zB+2]   # excess items  explainable
    xB = cB-cA+1 < border[zB]   # excess coins. explainable
    if     xA and not xB: return -1
    if not xA and     xB: return +1
    return +1 if zA*cA >= zB*cB else -1

#-----------------------------------------------------------------------

def red_strict1 (zA, cA, zB, cB, border):
    '''red_strict1 (zA, cA, zB, cB, border)
Reduce with excess coincidences : filter with signature (zB,cB-cA+1)
and    with excess items/neurons: filter with signature (zA-zB+2,cA)
and number of covered points/spikes: (zA-1)*cA versus (zB-1)*cB.
Use number of covered points/spikes to break ties.
zA      size    of pattern A (number of items)
cA      support of pattern A (number of coincidences)
zB      size    of pattern B (number of items)
cB      support of pattern B (number of coincidences)
border  detection border as a list of minimum support values per size
returns +1 if pattern A is preferred, -1 if pattern B is preferred,
        and 0 if neither pattern is preferred to the other'''
    if cA >= cB: return +1      # same support: prefer superset
    xA = cA < border[zA-zB+2]   # excess items  explainable
    xB = cB-cA+1 < border[zB]   # excess coins. explainable
    if     xA and not xB: return -1
    if not xA and     xB: return +1
    return +1 if (zA-1)*cA >= (zB-1)*cB else -1

#-----------------------------------------------------------------------

cmpfns  = [red_none,
           red_coins0, red_coins1, red_items2, red_cover0, red_cover1,
           red_leni0,  red_leni1,  red_strict0, red_strict1]
cmpdict = {'x': red_none,
           'c': red_coins0,  'C': red_coins1, 'i': red_items2,
           's': red_cover0,  'S': red_cover1,
           'l': red_leni0,   'L': red_leni1,
           't': red_strict0, 'T': red_strict1}

#-----------------------------------------------------------------------

def patred (pats, method='S', border=[], addis=False):
    '''patred (patterns, method='S', border=[], addis=False)
Perform pattern set reduction based on a preference relation.
pats    set of patterns to reduced as an iterable of pairs
        (item set, support), with each item set an iterable
        of items; each item must be a hashable object
method  index or identifier of pattern comparison method or
        a pattern comparison function patcmp(zA, cA, zB, cB, border)
border  detection border as a list of minimum support values per size
addis   whether to add intersections of patterns
returns a reduced set of patterns'''
    if isinstance(method, (0).__class__): patcmp = cmpfns [method]
    elif method in cmpdict:               patcmp = cmpdict[method]
    else:                                 patcmp = method
    if not patcmp or patcmp == red_none:
        return pats             # check for actual reduction
    pats = [(len(p),frozenset(p),c) for p,c in pats]
    pats = sorted(pats)         # prepare patterns (turn into sets)
    pmax = pats[-1][0] if pats else 0
    if pmax >= len(border):     # prepare and sort patterns
        border = border +[0 for i in range(pmax-len(border)+1)]
    s = [1 for p in pats]       # initialize the selector flags
    for iA in range(len(pats)): # traverse the (sorted) patterns
        zA,A,cA = pats[iA]      # get the next pattern
        for iB in range(iA):    # check against subsets
            if not s[iA] and not s[iB]: continue
            zB,B,cB = pats[iB]  # get the next pattern
            P = A & B; zP = len(P)
            if zP <= 0: continue# compute pattern intersection
            if zP >= zB:        # if pattern B is subset of A
                r = patcmp(zA, cA, zB, cB, border)
                if   r > 0: s[iB] = 0  # compare patterns and
                elif r < 0: s[iA] = 0  # unmark disfavored one
                continue        # if the intersection is proper:
            cP = max(cA, cB)    # get its support estimate
            if not addis or cP < border[zP]: continue
            iQ = bisect_left(pats, (zP,P,cP))
            for iQ in range(iQ, len(pats)):
                zQ,Q,cQ = pats[iQ]
                if zQ <= zP:    # traverse remaining patterns
                    if Q == P: break
                    continue    # skip smaller patterns
                if P <= Q and patcmp(zQ, cQ, zP, cP, border) < 0:
                    s[iQ] = 0   # filter with intersection
    return [(p[1],p[2]) for p,i in zip(pats,s) if i]

#-----------------------------------------------------------------------

def getredfn (i):
    '''getredfn (i)
Get pattern set reduction function via an identifier.
i       identifier of the pattern set reduction function
returns a pattern set reduction function'''
    if isinstance(i, (0).__class__):
        if i < 0: return len(cmpfns)
        return lambda p,m=i,b=[],a=False: patred(p,m,b,a)
    elif i in cmpdict:
        return lambda p,m=i,b=[],a=False: patred(p,m,b,a)
    else: return len(redfns)

#-----------------------------------------------------------------------

if __name__ == '__main__':
    pats = [((1,2,3,4,5,6,7), 7),
            ((1,2,3,8),       4)]
    print('before:')
    for p in pats: print(p)
    pats = patred(pats, 'S', [], True)
    print('after:')
    for p in pats: print(p)
