#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2016 mchristof <mchristof@ananke>
#
# Distributed under terms of the MIT license.

"""
Print out an elasticsearch cluster status
"""

import urllib2
import json
import ConfigParser
import os


def red(text):
    """ format a string with red color for awesome """
    return '<span foreground="red">{}</span>'.format(text)


def get_url():
    """docstring for get_url"""
    config = ConfigParser.ConfigParser()
    config.readfp(open(os.path.expanduser('~/.stuff.cfg')))
    return config.get('elasticsearch_status', 'url')


def elasticsearch_status():
    """ print out elasticsearch cluster status with lua colored format """
    response = urllib2.urlopen(get_url(), timeout=3)
    health = json.loads(response.read())
    widget_text = '<span foreground="{}">{}</span>'.format(
        health['status'],
        health['cluster_name'])
    if health['active_shards_percent_as_number'] != 100:
        widget_text += "[{}]".format(int(
            health['active_shards_percent_as_number']))
    return widget_text


def main():
    """ construct the string and print it """
    ret = ''
    try:
        ret += elasticsearch_status()
    except urllib2.URLError:
        ret += red('vpnc')
    print ret

if __name__ == '__main__':
    main()
