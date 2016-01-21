#!/usr/bin/env python2

import os
import sys
import argparse
import re
import time

header = """<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0"
        xmlns:media="http://search.yahoo.com/mrss/"
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:flickr="http://flickr.com/services/feeds/">
    <channel>
        <title>downloaded</title>
        <description></description>
        <pubDate>Thu, 1 Jan 2000 00:00:00 -0800</pubDate>
        <lastBuildDate>Thu, 1 Jan 2000 00:00:00 -0800</lastBuildDate>
"""
footer = """
    </channel>
</rss>
"""

item = """
    <item>
      <pubDate>DATE</pubDate>
      <title>TITLE</title>
      <description />
      <link>LINK</link>
      <enclosure type="video/avi" length="LENGTH" url="http://192.168.0.42/torrents/LINK" />
    </item>
"""

parser = argparse.ArgumentParser()
parser.add_argument('-d', '--dirs',
        help='Directories to list')
parser.add_argument('--extensions',
        action='append',
        default=['mp4', 'avi'],
        help='Type of files to list')
parser.add_argument('-e', '--episodes-only',
        action='store_true',
        help='List only the episodes found')
parser.add_argument('-a', '--absolute-path',
        action='store_true',
        help='Print files with absolute path')
parser.add_argument('-o', '--output',
        help='Output file to use')
args, unknown_args = parser.parse_known_args()


if args.output is None:
    args.output = args.dirs.replace('/', '_') + '.xml'

with open(args.output, "w") as out:
    out.write(header)
    for d in args.dirs:
        for root, dirs, filenames in os.walk(args.dirs):
                for f in filenames:
                    if args.episodes_only and \
                        not re.search('[sS]\d*[eE]\d*', f):
                        continue
                    if f.split('.')[-1:][0] in args.extensions:
                        path = os.path.join(root, f)
                        if args.absolute_path:
                            print "absotulint"
                            path = os.path.abspath(path)
                        to_print = item
                        to_print = re.sub('TITLE', f, to_print)
                        to_print = re.sub('LINK', path, to_print)
                        to_print = re.sub('LENGTH', str(os.path.getsize(path)), to_print)
                        (mode, ino, dev, nlink, uid, gid, size, atime, mtime, ctime) = os.stat(path)
                        date = time.strftime('%a, %d %b %Y %H:%M:%S %z', time.localtime(mtime))
                        to_print = re.sub('DATE', date, to_print)
                        # out.write("<a href='http://192.168.0.42/torrents/" + path + "'>" + path + "</a>\n")
                        out.write(to_print)
    out.write(footer)
