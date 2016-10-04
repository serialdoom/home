#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2016 mchristof <mchristof@Mikes-MacBook-Pro.local>
#
# Distributed under terms of the MIT license.

"""

"""

from sh import googler
import json


def main():
    """docstring for main"""
    import argparse
    parser = argparse.ArgumentParser(
        description='find ansible doc help online')
    # subparsers = parser.add_subparsers(help='commands')
    parser.add_argument('-x', '--example',
                        action='store_true',
                        help='Display the example link')
    parser.add_argument('-o', '--options',
                        action='store_true',
                        help='Display the options link')

    parser.add_argument('-q', '--query',
                        help='Query term')
    args = parser.parse_args()

    results = json.loads(str(googler('--json',
                                     'ansible module ' + args.query)))

    alfred_items = []
    for item in results:
        url = item['url']
        if args.options:
            url += '#options'
        elif args.example:
            url += '#examples'
        alfred_items += [{
            'title': item['title'],
            'arg': url,
            'subtitle': item['abstract'],
        }]
    res = {
        'items': alfred_items,
    }

    print json.dumps(res, indent=4)

if __name__ == '__main__':
    main()
