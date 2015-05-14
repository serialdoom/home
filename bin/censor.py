#!/usr/bin/env python

import sys
import time
import re
import hashlib
import ConfigParser
import os


hash_table = {}
translations = open("translations.txt", "w")
config = ConfigParser.RawConfigParser()
config.readfp(open(os.path.expanduser('~/.censor.cfg')))
print config.items("censor")

for arg in sys.argv:
    print "Checking file", arg
    with open(arg, "r") as f:
        with open(arg + ".txt", "w") as out:
            for line in f.xreadlines():
                for regex in config.items("censor"):
                    match = re.search(regex[0], line, re.IGNORECASE)
                    if match:
                        try:
                            hash_table[match.group(1)]
                        except IndexError:
                            print "index error [", line, "]", regex[0]
                        except KeyError:
                            # first time we saw one of those, store
                            # it for later.
                            hash_table[match.group(1)] = hashlib.sha224(match.group(1)).hexdigest()
                            translations.write(match.group(1) + " " + hash_table[match.group(1)] + "\n")
                        line = re.sub(match.group(1), hash_table[match.group(1)], line)
                out.write(line)

translations.close()
