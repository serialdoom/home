#!/usr/bin/env python

import sys
import time
import re
import hashlib
import ConfigParser
import os
import argparse

cfg_name = os.path.expanduser("~/.censor.cfg")
parser = argparse.ArgumentParser()
parser.add_argument("-p", "--profile",
        action="store",
        dest="profile",
        default="default",
        help="Profile to use")
args, unknown_args = parser.parse_known_args()

hash_table = {}
translations = open("translations.txt", "w")
config = ConfigParser.RawConfigParser()
try:
    config.readfp(open(cfg_name))
except IOError:
    print "Config file", cfg_name, "not found."
    print "A default is created but you'll need to add some stuff to it"
    with open(cfg_name, "w") as f:
        f.write("[default]\n(peos.*) =\n#(soumada\w*) =\n")
        f.write("# Remember to surround your regexs with parenthesis\n\n")
        f.write("#or create your own_profile with\n#[own_profile]\n# and use with \"-p own_profile\"\n")
    sys.exit(1)
print "Censoring with profile", args.profile, "\n", config.items(args.profile)

for arg in unknown_args:
    print "Checking file", arg
    with open(arg, "r") as f:
        with open(arg + ".txt", "w") as out:
            for line in f.xreadlines():
                for regex in config.items(args.profile):
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
