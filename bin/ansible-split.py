#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2016 mchristof <mchristof@Mikes-MacBook-Pro.local>
#
# Distributed under terms of the MIT license.

"""

"""

import os
import json
from ansible.parsing.dataloader import DataLoader
from ansible.vars import VariableManager
from ansible.inventory import Inventory
from sh import osascript, echo


def main():
    """docstring for main"""
    import argparse
    parser = argparse.ArgumentParser(
        description='Splits iterm2 with ansible filters')
    # subparsers = parser.add_subparsers(help='commands')

    parser.add_argument('-l', '--limit',
                        help='Limmit ansible hosts to this')
    parser.add_argument('-i', '--inventory',
                        default=os.getenv('ALFRED_ANSIBLE_INVENTORY', None),
                        help='Inventory file to use')

    parser.add_argument('-x', '--execute',
                        action='append',
                        default=None,
                        nargs='*',
                        help='Execute a split from either the limit result'
                        ' or the provided args')
    parser.add_argument('--vertical',
                        action='store_true',
                        help='Split vertically')

    parser.add_argument('--hosts',
                        help='Hosts to split to, comma separated')
    parser.add_argument('-n', '--dry',
                        action='store_true',
                        help='Dry run')

    parser.add_argument('-v', '--verbose',
                        action='count',
                        default=0,
                        help='Increase verbosity')

    args = parser.parse_args()

    if args.limit is not None:
        if not args.limit.startswith('~'):
            args.limit = '~' + args.limit
        items = ansible_list(args.limit, args.inventory)
        if args.execute is None:
            print json.dumps({
                'items': items,
            }, indent=4)
    if args.execute is not None:
        if args.limit:
            host_list = items[0]['arg'].split(',')
        else:
            host_list = [item for sublist in args.execute
                         for item in sublist][0].split(',')
        iterm2_split(host_list, args.vertical, args.dry)


def host_to_profile(host):
    """docstring for host_to_profile"""
    return "{}.decibelinsight.net".format(host)


def iterm2_split(hosts, vertical=True, dry=False):
    if vertical:
        orientation = 'vertically'
    else:
        orientation = 'horizontally'
    script = [
        """tell application "iTerm2" """,
    ]
    if len(hosts) > 1:
        script += [
            """  tell current window""",
            """    select (create tab with profile "{}") """.format(
                host_to_profile(hosts[0])),
            """  end tell """,
            """end tell """,
            """tell application "iTerm2" """,
            """    tell current session of current window """,
        ]
    else:
        print host_to_profile(hosts[0])
        script += [
            """    tell current session of current window """,
            """      split {} with profile "{}" """.format(
                orientation,
                host_to_profile(hosts[0]))
            ]

    for host in hosts[1:]:
        script += [
            """ split {} with profile "{}" """.format(
                orientation,
                host_to_profile(host))
        ]

    script += [
        """end tell """,  # current tab
        """end tell """  # application
    ]
    script = '\n'.join(script)
    if not dry:
        osascript(echo(script))
    else:
        print script


def ansible_list(limit, inventory):
    """docstring for ansible_list"""
    loader = DataLoader()
    variable_manager = VariableManager()
    inventory = Inventory(loader=loader,
                          variable_manager=variable_manager,
                          host_list=inventory)
    hosts = inventory.list_hosts(pattern=limit)
    # import pdb; pdb.set_trace()
    groups = [x.get_groups() for x in hosts]
    groups = list(set([item for sublist in groups for item in sublist]))
    groups.sort(key=lambda x: x.depth, reverse=True)
    names = [x.name for x in hosts]
    ret = [{
        'arg': ','.join(names),
        'title': ','.join(names),
    }]

    for name in names:
        ret += [{
            'arg': name,
            'title': name,
        }]
    for group in groups:
        group_hosts = [x.name for x in group.get_hosts()]
        ret += [{
            'title': group.name,
            'arg': ','.join(group_hosts),
            'valid': len(group_hosts) < 10,
        }]
    return ret

if __name__ == '__main__':
    main()
