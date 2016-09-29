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
import requests
import hashlib
from sh import git
from sh import vim
import re


def get_current_vim_file(server=None):
    if server is None:
        server = str(vim('--serverlist')).rstrip()
        if server is '':
            return None
    return (str(vim('--servername', server,
                    '--remote-expr', 'expand("%:p")')).rstrip(),
            str(vim('--servername', server,
                    '--remote-expr', 'line(".")')).rstrip())


class Gitlab():
    def __init__(self, url, token, cache):
        self.url = url
        self.token = token
        self.projects = None
        self.cache = '/tmp/gitlab-py'
        self.enable_cache = cache
        if not os.path.exists(self.cache):
            os.makedirs(self.cache)

    def file(self, path, vim=False, vim_server=None):
        line = None
        if vim:
            path, line = get_current_vim_file(vim_server)
        if path is None:
            return None
        # print 'finding', path, len(path.split('/')), line
        for i in range(len(path.split('/')), 0, -1):
            current = os.path.join("/".join(path.split('/')[0:i]), '.git')
            fname = "/".join(path.split('/')[i:])
            if os.path.exists(current):
                # print current
                break
        # sample line
        # deploy-git         ssh://git@deploy-git.decibelinsight.net/ansible/logstash (fetch) # NOQA
        #         ->         <- this is a tab
        remote = str(git('--git-dir', current, 'remote', '-v')).split('\n')[0]
        remote = remote.split('\t')[1]
        remote = remote.split(' ')[0]
        remote = re.sub('^ssh://git@', '', remote)
        remote = re.sub('^git@', '', remote)
        remote = re.sub(':', '/', remote)
        remote = re.sub('.git$', '', remote)
        # print remote
        branch = str(git('--git-dir', current,
                         'rev-parse', '--abbrev-ref', 'HEAD')).rstrip()
        url = 'https://{}/blob/{}/{}'.format(remote, branch, fname)
        if line is not None:
            url = url + '#L' + line
        return (url, fname)

    def curl(self, url):
        url = '{u}/api/v3/{url}'.format(
            u=self.url, url=url)
        # print url
        r = requests.get(url,
                         headers={
                             'PRIVATE-TOKEN': self.token,
                         })
        try:
            if r.json()['message'] == '403 Forbidden':
                print r.json()['message']
                exit(1)
        except TypeError:
            pass
        return r.json()

    def get_projects(self):
        """docstring for get_project_from_gitlab"""
        if self.projects is not None:
            return self.projects

        self.projects = {}
        for i in range(0, 1000):
            url = '{u}/api/v3/projects/?page={i}&per_page=30'.format(
                i=i,
                u=self.url)
            r = requests.get(url,
                             headers={
                                 'PRIVATE-TOKEN': self.token,
                             })
            # print r.json()
            try:
                if r.json()['message'] == '403 Forbidden':
                    print r.json()['message']
                    exit(1)
            except TypeError:
                pass
            for proj in r.json():
                self.projects.update(proj)
        return self.projects

    def hash_file(self, query):
        return os.path.join(self.cache,
                            hashlib.md5(query).hexdigest())

    def load_from_cache(self, query):
        try:
            with open(self.hash_file(query)) as fyle:
                return json.load(fyle)
        except IOError:
            # cache not available
            pass
        return None

    def search(self, query=None, postfix=''):
        if query is None:
            return None
        ret = self.load_from_cache(query+postfix)
        if not self.enable_cache or ret is None:
            ret = {'items': []}
            for proj in self.curl('projects/?search={}'.format(query)):
                ret['items'] += [{
                    'title': proj['name_with_namespace'],
                    'arg': proj['web_url'] + postfix,
                }]

        with open(self.hash_file(query+postfix), 'w+') as stream:
            stream.write(json.dumps(ret, indent=4))
        return ret


def main():
    """docstring for main"""
    import argparse
    parser = argparse.ArgumentParser(
        description='Alfred help script to display gitlab repo infos')
    # subparsers = parser.add_subparsers(help='commands')

    parser.add_argument('-p', '--private-token',
                        default=os.getenv('GIT_TOKEN',
                                          None),
                        help='Gitlab private token')
    parser.add_argument('-u', '--gitlab-url',
                        default=os.getenv('GITLAB_URL', None),
                        help='Gitlab base url')
    parser.add_argument('-q', '--query',
                        help='Name of the project to find')
    parser.add_argument('--no-cache',
                        dest='cache',
                        default=True,
                        action='store_false',
                        help='Disable cache')
    parser.add_argument('--postfix',
                        default='',
                        help='Add something to the url results (for '
                        'getting branches/pipelines/etc)')
    parser.add_argument('--vim',
                        action='store_true',
                        help='Enable vim mode for file (query vim for current '
                        'file)')
    parser.add_argument('-s', '--vim-server',
                        help='Vim server to query for a file name')
    parser.add_argument('-f', '--file',
                        help='Specific file to go to')

    args = parser.parse_args()

    if args.private_token is None:
        print 'Error, private token not set/found'
        exit(1)
    if args.gitlab_url is None:
        print 'Error, gitlab url not set/found'
        exit(1)

    gl = Gitlab(args.gitlab_url, args.private_token, args.cache)
    res = gl.search(args.query, args.postfix)
    if res is None:
        res = {
            'items': []
        }
        try:
            (url, fyle) = gl.file(args.file, True, args.vim_server)
            res['items'] = [{
                'title': fyle,
                'arg': url,
            }]
        except TypeError:
            pass
    print json.dumps(res, indent=4)


if __name__ == '__main__':
    main()
