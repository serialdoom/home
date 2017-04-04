#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2017 mhristof <mhristof@Mikes-MacBook-Pro.local>
#
# Distributed under terms of the MIT license.

import os
import re
import json
from operator import itemgetter
from slackclient import SlackClient

class MSlack():
    def __init__(self, token):
        self.sc = SlackClient(token)
        self.channels = None

    def get_channels(self):
        self.channels = [{'name': x['name'], 'id': x['id'], 'type': 'groups'} for x in self.sc.api_call("groups.list")['groups']]
        self.channels += [{'name': x['name'], 'id': x['id'], 'type': 'channels' } for x in self.sc.api_call('channels.list')['channels']]
        return self.channels

    def get_messages(self, cid, count=15):
        if self.channels is None:
            self.get_channels()

        for item in self.channels:
            if cid == item['id']:
                return self.sc.api_call(item['type'] + '.history', channel=cid, count=count)['messages'], item['name']


def get_links(messages, channel='unknown'):
    ret = []
    for msg in messages:
        search = re.search('(http.*?)(\s|>)', msg['text'])
        if search:
            ret += [{
                'title': search.groups()[0],
                'arg': search.groups()[0],
                'quicklookurl': search.groups()[0],
                'subtitle': channel,
                'ts': msg['ts']
            }]
    return ret

def main():
    """docstring for main"""
    import argparse
    parser = argparse.ArgumentParser(description='Retrieves links posted in slack')
    # subparsers = parser.add_subparsers(help='commands')

    parser.add_argument('-c', '--count',
                        type=int,
                        default=10,
                        help='Limit the number of links')
    parser.add_argument('-l', '--limit',
                        default=None,
                        help='Limit the search to this channel (regex search)')

    parser.add_argument('-a', '--alfred',
                        action='store_true',
                        help='Alfred parsable output')

    args = parser.parse_args()

    slack = MSlack(os.environ["SLACK_API_TOKEN"])

    links = []
    for item in slack.get_channels():
        if args.limit is not None and not re.search(args.limit, item['name']):
            continue
        msgs, name = slack.get_messages(item['id'])
        links += get_links(msgs, name)

    links = sorted(links, key=itemgetter('ts'), reverse=True)
    if len(links) > args.count:
        links = links[0:args.count]
    if args.alfred:
        links = {
            'items': links
        }
    print json.dumps(links, indent=4)

if __name__ == '__main__':
    main()
