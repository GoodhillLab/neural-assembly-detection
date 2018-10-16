#!/usr/bin/python
#-----------------------------------------------------------------------
# File    : fim+psf+psr.py
# Contents: Pattern Spectrum Filtering and Pattern Set Reduction
#           (for transactional data/frequent item set mining)
# Author  : Christian Borgelt
# History : 2014.05.06 file created from file psf+psr.py
#           2014.05.12 pattern spectrum border passed to fim
#           2015.08.12 adapted to modified pattern set reduction
#           2015.09.04 adapted to modified value report behavior
#-----------------------------------------------------------------------
from sys     import argv, stderr, path, version_info
from os.path import join
from time    import time
from math    import floor, ceil
from fim     import fim, genpsp, estpsp, psp2bdr, patred

#-----------------------------------------------------------------------
# Constants
#-----------------------------------------------------------------------
oo = float('inf')               # positive infinity as a constant

#-----------------------------------------------------------------------
# File Reading Function
#-----------------------------------------------------------------------

def getrec (f, recseps, fldseps, blanks, comment):
    '''Read a record from a file and split it into fields.
f       file to read from
recseps record  separators
fldseps field   separators
blanks  blank   characters
comment comment characters
returns a list of the fields read or None at end of file'''
    c = f.read(1).decode()      # read the next character
    while c != '' and c in comment:
        while c != '' and c not in recseps:
            c = f.read(1).decode() # skip comment until record separator
        c = f.read(1).decode()  # consume the record separator
    if c == '': return None     # if at end of file, abort
    rec = []                    # initialize the record
    sep = fldseps +recseps      # combine all separators
    while 1:                    # field read loop
        while c != '' and c in blanks:
            c = f.read(1).decode() # skip leading blanks
        fld = ''                # initialize the field
        while c != '' and c not in sep:
            fld += c            # append character to the field
            c = f.read(1).decode()  # and read the next character
        fld = fld.strip(blanks) # remove leading/trailing blanks */
        if len(fld) > 0:        # if the field is not empty,
            rec.append(fld)     # append the field to the record
        if c == '' or c in recseps: break
        c = f.read(1).decode()  # consume field separator
    return rec                  # return the record

#-----------------------------------------------------------------------
# Main Program
#-----------------------------------------------------------------------

def error (msg):
    stderr.write(msg); exit()   # print an error message and abort

#-----------------------------------------------------------------------

if __name__ == '__main__':
    desc    = 'Pattern Spectrum Filtering and Pattern Set Reduction\n' \
            + '(for transactional data/frequent item set mining)'
    version = 'version 1.3 (2015.08.15)         ' \
            + '(c) 2014-2015   Christian Borgelt'
    args    = []                # list of program arguments/options
    opts    = {'t': ['target', 'c' ],  # target type
               'u': ['starg',  's' ],  # target type for surrogates
               's': ['supp', -2    ],  # minimum support (absolute)
               'm': ['zmin',  2    ],  # minimum number of items
               'n': ['zmax', -1    ],  # maximum number of items
               'g': ['surr',  'p'  ],  # surrogate generation method
               'e': ['alpha', 0.5  ],  # probability dispersion factor
               'i': ['smpls', 1000 ],  # samples per item set size
               'S': ['seed',  0    ],  # seed for random numbers
               'c': ['cnt',   1000 ],  # number of data sets
               'Z': ['cpus',  0    ],  # number of cores/cpus to use
               'R': ['pred',  'L'  ],  # pattern set reduction
               'q': ['pssep', ' '  ],  # pattern spectrum separator
               'h': ['ishdr', ''   ],  # record header  for output
               'k': ['isep',  ' '  ],  # item separator for output
               'v': ['outfmt',' (%d)'],# output format for support
               'r': ['recseps', '\\n' ],     # record  separators
               'f': ['fldseps', ' ,\\t' ],   # field   separators
               'b': ['blanks',  ' \\t\\r' ], # blank   characters
               'C': ['comment', '#' ],       # comment characters
               'P': ['pspfn',  ''  ] } # name of pattern spectrum file

    if len(argv) <= 1:          # if no arguments are given
        opts = dict([(o,opts[o][1]) for o in opts])
        print('usage: fim+psf+psr.py [options] infile [outfile]')
        print(desc); print(version)
        print('-t#      target type for original data          '
                      +'(default: %s)' % opts['t'])
        print('-u#      target type for surrogate data         '
                      +'(default: %s)' % opts['u'])
        print('         s    frequent item sets')
        print('         c    closed  (frequent) item sets')
        print('         m    maximal (frequent) item sets')
        print('-s#      minimum support of an item set         '
                      +'(default: %g)' % opts['s'])
        print('         (positive: percentage, '
                      +'negative: absolute number)')
        print('-m#      minimum number of items per item set   '
                      +'(default: %d)' % opts['m'])
        print('-n#      maximum number of items per item set   '
                      +'(default: no limit)')
        print('-g#      surrogate generation method            '
                      +'(default: %s)' % opts['g'])
        print('         x    none (read pattern spectrum from file)')
        print('         i    identity (keep original data)')
        print('         r    random transaction generation')
        print('         p    permutation by pair swaps')
        print('         s    shuffle table-derived data (columns)')
        print('         e    estimate pattern spectrum (no surrogates)')
        print('-c#      number of surrogate data sets          '
                      +'(default: %d)' % opts['c'])
        print('         (if <= 0, the pattern spectrum is read '
                      +'from a file)')
        print('-Z#      number of cpus/processor cores to use  '
                      +'(default: %g)' % opts['Z'])
        print('         (a value <= 0 means all cpus reported '
                      +'as available)')
        print('-e#      probability dispersion factor          '
                      +'(default: %g)' % opts['e'])
        print('-i#      number of item set samples per size    '
                      +'(default: %d)' % opts['i'])
        print('-R#      pattern set reduction method           '
                      +'(default: %s)' % opts['R'])
        print('         x     none (keep all patterns after filtering)')
        print('         c     excess coincidences    '
                      +'(zb,cb-ca)')
        print('         C     excess coincidences    '
                      +'(zb,cb-ca+1)')
        print('         i     excess items/neurons   '
                      +'(za-zb+2,ca)')
        print('         s     covered points/spikes  '
                      +'za*ca : zb*cb')
        print('         S     covered points/spikes  '
                      +'(za-1)*ca : (zb-1)*cb')
        print('         l     combined lenient       '
                      +'(C+i+s, break only rejection tie)')
        print('         L     combined lenient       '
                      +'(C+i+S, break only rejection tie)')
        print('         t     combined strict        '
                      +'(C+i+s, always force decision)')
        print('         T     combined strict        '
                      +'(C+i+S, always force decision)')
        print('-S#      seed for pseudo-random numbers         '
                      +'(default: %d)' % opts['S'])
        print('-P#      name of pattern spectrum file          '
                      +'(default: none)')
        print('-q#      column separator for pattern spectrum  '
                      +'(default: "%s")' % opts['q'])
        print('-h#      record  header for output              '
                      +'(default: "%s")' % opts['h'])
        print('-k#      item separator for output              '
                      +'(default: "%s")' % opts['k'])
        print('-v#      output format for pattern support      '
                      +'(default: "%s")' % opts['v'])
        print('-r#      record  separators                     '
                      +'(default: "%s")' % opts['r'])
        print('-f#      field   separators                     '
                      +'(default: "%s")' % opts['f'])
        print('-b#      blank   characters                     '
                      +'(default: "%s")' % opts['b'])
        print('-C#      comment characters                     '
                      +'(default: "%s")' % opts['C'])
        print('infile   file to read transactions from         '
                      +'[required]')
        print('outfile  file to write found item sets to       '
                      +'[optional]')
        exit()                  # print usage message and abort

    stderr.write('fim+psf+psr.py') # print a startup message
    stderr.write(' - ' +desc +'\n' +version +'\n')

    # --- evaluate program options and arguments ---
    for a in argv[1:]:          # traverse the program arguments
        if a[0] != '-':         # check for a fixed argument
            if len(args) < 2: args.append(a); continue
            else: error('too many arguments\n')
        if a[1] not in opts:    # check for an option
            error('unknown option: %s\n' % a[:2])
        o = opts[a[1]]          # get the corresponding option
        v = a[2:]               # and get the option argument
        if   isinstance(o[1],True.__class__): o[1] = not o[1]
        elif isinstance(o[1], (0).__class__): o[1] = int(v)
        elif isinstance(o[1], 0.0.__class__): o[1] = float(v)
        else:                                 o[1] = v
    if len(args) < 1: error('missing arguments\n')
    opts = dict([opts[o] for o in opts])

    target  = opts['target']    # target type for CoCoNAD
    starg   = opts['starg']     # target type for surrogates (patspec)
    zmin    = opts['zmin']      # minimum size of item sets
    zmax    = opts['zmax']      # maximum size of item sets
    supp    = opts['supp']      # minimum support for CoCoNAD
    surr    = opts['surr']      # surrogate data generation method
    alpha   = opts['alpha']     # probability dispersion factor
    smpls   = opts['smpls']     # number of item set samples per size
    seed    = opts['seed']      # random seed (0: use time)
    cnt     = opts['cnt']       # number of surrogate data sets
    cpus    = opts['cpus']      # number of cpus/cores to use
    pred    = opts['pred']      # pattern set reduction method
    pssep   = opts['pssep']     # pattern spectrum separator
    ishdr   = opts['ishdr']     # record header  for output
    isep    = opts['isep']      # item separator for output
    outfmt  = opts['outfmt']    # output format for support
    recseps = opts['recseps']   # record  separators
    fldseps = opts['fldseps']   # field   separators
    blanks  = opts['blanks']    # blank   characters
    comment = opts['comment']   # comment characters
    pspfn   = opts['pspfn']     # pattern spectrum file name
    if zmin <= 0: error('invalid minimum size %d\n'    % zmin)
    if surr not in 'xirpse':    # check surrogate generation method
        error('invalid surrogate data generation %s\n' % surr)
    if pred not in 'xcCisSlLtT':# check pattern set reduction
        error('invalid pattern set reduction %s\n'     % pred)
    if surr == 'x': cnt = 0     # adapt number of data sets
    if cnt <= 0 and pspfn == '':# check for a pattern spectrum
        error('need to generate surrogates or read pattern spectrum\n')
    x = [recseps,fldseps,blanks,comment]
    if version_info[0] >= 3:    # decode ASCII escape sequences
        x = [bytes(s, 'utf-8').decode('unicode_escape') for s in x]
    else:                       # decode ASCII escape sequences
        x = [s.decode('string_escape') for  s in x]
    recseps,fldseps,blanks,comment = x

    # --- read the data set to analyze ---
    t = time()                  # start timer, print log message
    stderr.write('reading %s ... ' % args[0])
    items  = set()              # initialize the set of items
    tracts = []; k = 1          # initialize the transactions
    with open(args[0], 'rb') as inp:
        while 1:                # record read loop
            rec = getrec(inp, recseps, fldseps, blanks, comment)
            if rec == None: break
            if not rec: continue# read the next record
            items |= set(rec)   # collect items in a set
            tracts.append(rec)  # and transactions in a list
    stderr.write('[%d item(s), %d transaction(s)]'
                 % (len(items), len(tracts)))
    stderr.write(' done [%.2fs].\n' % (time()-t))
    if supp > 0: supp = -ceil(0.01 *supp *len(tracts))

    if surr == 's':             # check whether data is table derived
        if len(set(len(t) for t in tracts)) != 1:
            print('for shuffle surrogates transactions '
                 +'must have equal size'); exit()
        items = dict([(i,set()) for i in items])
        for t in tracts:        # collect items per position/column
            for i in range(len(t)): items[t[i]].add(i)
        for i in items:         # check occurrence of items
            if len(items[i]) != 1:
                print('for shuffle surrogates '
                     +'%s must occur in only one column'); exit()

    # --- read or generate pattern spectrum ---
    t = time()                  # start timer, print log message
    if cnt <= 0:                # if to read a pattern spectrum
        stderr.write('reading %s ... ' % pspfn)
        psp = dict()            # initialize a pattern spectrum
        with open(pspfn, 'r') as inp:
            for line in inp:    # read pattern spectrum from file
                z,c,n = line.split()
                psp[int(z),int(c)] = float(n)
    elif surr == 'e':           # if to estimate a pattern spectrum
        stderr.write('estimating pattern spectrum ... '); stderr.flush()
        psp = estpsp (tracts, starg, supp, zmin, zmax, '#',
                      cnt, alpha, smpls, seed)
    else:                       # if to generate a pattern spectrum
        stderr.write('generating pattern spectrum ... '); stderr.flush()
        psp = genpsp(tracts, starg, supp, zmin, zmax, '#',
                     cnt, surr, seed, cpus)
    stderr.write('[%d signature(s)]' % len(psp))
    stderr.write(' done [%.2fs].\n' % (time()-t))
    border = psp2bdr(psp)       # extract the decision border

    # --- save generated pattern spectrum ---
    if cnt > 0 and pspfn != "": # if file name for pattern spectrum
        t = time()              # start timer, print log message
        stderr.write('writing %s ... ' % pspfn)
        with open(pspfn, 'w') as out: # write pattern spectrum to a file
            for s in sorted([(z,c,psp[z,c]) for z,c in psp]):
                out.write(('%d'+pssep+'%d'+pssep+'%.16g\n') % s)
        stderr.write('[%d signature(s)]' % len(psp))
        stderr.write(' done [%.2fs].\n' % (time()-t))

    # --- analyze original data set ---
    if len(args) < 2: exit()    # check for an output file name
    t = time()                  # start timer, print log message
    stderr.write('analyzing original data ... ')
    pats = fim(tracts, target, supp, zmin, zmax, 'a', border=border)
    stderr.write('[%d pattern(s)]' % len(pats))
    stderr.write(' done [%.2fs].\n' % (time()-t))

    # --- pattern set reduction ---
    if pred != 'x':             # if to filter with pattern spectrum
        t = time()              # start timer, print log message
        stderr.write('reducing pattern set ... ')
        pats = patred(pats, pred, border, False)
        stderr.write('[%d pattern(s)]' % len(pats))
        stderr.write(' done [%.2fs].\n' % (time()-t))

    # --- write output file ---
    t = time()                  # start timer, print log message
    stderr.write('writing %s ... ' % args[1])
    with open(args[1], 'w') as out:
        for p,c in pats:        # traverse the reduced patterns
            p = sorted(p)       # sort the items in the pattern
            for i in p[:-1]: out.write(str(i)+isep)
            out.write(p[-1])    # write the items of the pattern
            out.write(outfmt % c)
            out.write('\n')     # write the support information
    stderr.write('[%d pattern(s)]' % len(pats))
    stderr.write(' done [%.2fs].\n' % (time()-t))
