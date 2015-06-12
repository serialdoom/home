#!/usr/bin/env python

import argparse
import subprocess

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-b",
            action="store",
            dest="build",
            default=None,
            help="Build all configs for the given project")
    parser.add_argument("-j",
            action="store",
            dest="job",
            help="Job name to alter")
    parser.add_argument("-U",
            action="store",
            dest="user_pass",
            help="Curl authentication data. This will be used as \"curl -u USER_PASS <url>\"")
    parser.add_argument("-u", "--url",
            action="store",
            dest="url",
            help="Jenkins base url")
    parser.add_argument("-d",
            action="store",
            nargs='*',
            dest="desc",
            help="description")
    parser.add_argument("-v",
            dest="verbose",
            action="count",
            help="Increase verbosity")
    

    args, unknown = parser.parse_known_args()


    cmd = "{curl} --silent -u {user} --data-urlencode \"description={d}\" --data-urlencode \"Submit=Submit\" \"{url}/job/{j}/{b}/submitDescription\"".format(
            url = args.url,
            u = args.user_pass,
            d = " ".join(args.desc),
            j = args.job,
            b = args.build,
            curl = "/home/mc42/tmp/install/bin/curl",
            )
    if args.verbose:
        print cmd
    subprocess.check_call(cmd, shell=True);
    # print args
