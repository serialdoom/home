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


def get_url():
    """docstring for get_url"""
    config = ConfigParser.ConfigParser()
    config.readfp(open(os.path.expanduser('~/.stuff.cfg')))
    return config.get('elasticsearch_status', 'url')


def main():
    """ print out elasticsearch cluster status with lua colored format """
    response = urllib2.urlopen(get_url())
    health = json.loads(response.read())
    if 'red' in health['status']:
        widget_text = '<span foreground="red">{}</span>'.format(
            health['cluster_name'])
        widget_text += "[{}]".format(int(
            health['active_shards_percent_as_number']))
    print widget_text

if __name__ == '__main__':
    main()
