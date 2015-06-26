#!/usr/bin/env python
import argparse
import hashlib
import os
from threading import BoundedSemaphore
import shelve
from multiprocessing import Pool
import re




def calculate_md5(fname):
    try:
        fnames_checked[fname]
        return None
    except KeyError:
        pass
    md5 = hashlib.md5(open(fname, 'rb').read()).hexdigest()
    return (md5, fname)

def register_sum(results):
    if results is None:
        return
    fname = results[1]
    md5 = results[0]

    dict_sema.acquire()
    fnames_checked[fname] = ""
    try:
        md5_hash[md5] += [fname]
    except KeyError:
        md5_hash[md5] = [fname]
    dict_sema.release()


parser = argparse.ArgumentParser()
parser.add_argument("-a", "--all",
        action="store",
        dest="all_configs",
        nargs = "*",
        default=None,
        help="Build all configs for the given project")
parser.add_argument("-j",
        action="store",
        dest="j",
        default=12,
        help="Use that many parallel threads")
parser.add_argument("--match",
        action="store",
        dest="match",
        default=None,
        help="Match only specific files")
args, unknown = parser.parse_known_args()


used_threads = 0
dict_sema = BoundedSemaphore()
md5_hash = shelve.open(".fdups_fdups.db")
fnames_checked = shelve.open(".fdups_flist.db")

p = Pool(int(args.j))
for f in unknown:
    for root, dirs, files in os.walk(f):
        for fyle in files:
            if re.search(args.match, fyle):
                p.apply_async(calculate_md5,
                        args = (os.path.join(root, fyle), ),
                        callback = register_sum)

p.close()
p.join()

for key in md5_hash.keys():
    print key, md5_hash[key]
    #if len(md5_hash[key]) > 1:
        #print hey, md5_hash[key]

fnames_checked.close()
md5_hash.close()
