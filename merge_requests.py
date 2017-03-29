#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2016 mchristof <mchristof@Mikes-MacBook-Pro.local>
#
# Distributed under terms of the MIT license.

"""
get merge requests from gitlab
"""

import os
import re
import time
import stat
import json
import urllib
import requests  # pylint: disable=import-error
from git import Repo
from sh import repo  # pylint: disable=import-error,no-name-in-module
from tqdm import tqdm


def sanitize(name):
    """ sanitize file names replacing slashes """
    return name.replace('/', '-')


class Cache(object):
    """ Initialize a cache item """
    def __init__(self, time_valid=3600, path=None):
        """ constructor

        args:
            time_valid (int): seconds of valid time (from creation time)
            path (str): path to cache
        """
        if path is not None:
            self.path = path
        else:
            self.path = '/tmp/merge_requests'
        self.time = time_valid

        if not os.path.exists(self.path):
            os.makedirs(self.path)

    def load(self, repo_id):
        """ load a file if its there and valid.

        args:
            repo_id (str): the id of the cache item
        """
        git_repo = sanitize(repo_id)
        fyle = os.path.join(self.path, git_repo)
        if os.path.exists(fyle) and \
                time.time() - os.stat(fyle)[stat.ST_MTIME] < self.time:
            with open(fyle) as stream:
                return json.load(stream)
        return None

    def save(self, repo_id, contents):
        """ save results into a cache file

        args:
            repo_id (str): id of the cache item
            contents (dict): cache contents
        """
        repo_id = sanitize(repo_id)
        with open(os.path.join(self.path, repo_id), 'w') as stream:
            stream.write(json.dumps(contents))


def get_merges(url, repo_name, token, cache=None):
    """docstring for get_merges"""
    base_url = '{}/api/v3/projects'.format(url)
    opened_merge_req_url = 'merge_requests?state=opened'
    repo_enc = urllib.quote_plus(repo_name)
    ret = None

    if cache is not None:
        ret = cache.load(repo_name)

    if ret is None:
        req = requests.get('{}/{}/{}'.format(base_url,
                                             repo_enc,
                                             opened_merge_req_url),
                           timeout=10,
                           headers={
                               'PRIVATE-TOKEN': token,
                           })
        ret = req.json()
        if cache is not None:
            cache.save(repo_name, ret)
    return {repo_name: ret}


def filter_merges(merges, assignee=None, author=None):
    """ filter merge requests """
    ret = {}
    for repository, merge_t in merges.iteritems():
        for merge in merge_t:
            if assignee is not None and \
                    'assignee' in merge and \
                    merge['assignee'] is not None and \
                    merge['assignee']['username'] == assignee:
                try:
                    ret[repository] += [{
                        'url': merge['web_url'],
                        'title': merge['title']
                    }]
                except KeyError:
                    ret[repository] = [{
                        'url': merge['web_url'],
                        'title': merge['title']
                    }]
            if author is not None and \
                    'author' in merge and \
                    merge['author']['username'] == author:
                try:
                    ret[repository] += [{
                        'url': merge['web_url'],
                        'title': merge['title']
                    }]
                except KeyError:
                    ret[repository] = [{
                        'url': merge['web_url'],
                        'title': merge['title']
                    }]

    return ret


def git_remote(path):
    """ get remote from a git repository """
    git_repo = Repo(path)
    remote = re.sub(r'.*\.net/', '', git_repo.remotes[0].url)
    return remote


def main():
    """docstring for main"""
    import argparse
    parser = argparse.ArgumentParser(
        description='Fetch information about merge requests')
    # subparsers = parser.add_subparsers(help='commands')

    parser.add_argument('-u', '--user',
                        default=os.getenv('USER'),
                        help='User to use for todo')

    parser.add_argument('-a', '--all',
                        action='store_true',
                        default=True,
                        help='Show infos for all repos')

    parser.add_argument('-r', '--repo',
                        help='Repo name to search for')

    parser.add_argument('-p', '--git-token',
                        default=os.getenv('GIT_TOKEN'),
                        help='Git token to use')

    parser.add_argument('-m', '--mine',
                        action='store_true',
                        help='Print infos for merge requests created by me')

    parser.add_argument('-C', '--cache-valid-time',
                        default=3600,
                        type=int,
                        help='Cache time validity. Set to 0 for cache'
                        ' invaldation')

    parser.add_argument('-G', '--gitlab-url',
                        default=os.getenv('GITLAB_URL'),
                        help='Gitlab base url, for example '
                        'https://gitlab.com')

    parser.add_argument('-s', '--silent',
                        action='store_true',
                        default=False,
                        help='Disable fancy output')

    parser.add_argument('-n', '--dry-ryn',
                        action='store_true',
                        help='Dry run mode')
    parser.add_argument('-v', '--verbose',
                        action='count',
                        default=0,
                        help='Increase verbosity')

    args = parser.parse_args()
    if args.repo is not None and os.path.exists(args.repo):
        merges = get_merges(args.gitlab_url,
                            git_remote(args.repo),
                            args.git_token)
    elif args.repo:
        merges = get_merges(args.gitlab_url, args.repo, args.git_token)
    elif args.all:
        repos = []
        for repo_line in str(repo('list')).split('\n'):
            try:
                repos += [repo_line.split(':')[1].strip()]
            except IndexError:
                pass
        merges = {}
        cache = Cache(time_valid=args.cache_valid_time)
        for i in tqdm(range(len(repos)), disable=args.silent):
            repository = repos[i]
            merges.update(get_merges(args.gitlab_url,
                                     repository,
                                     args.git_token,
                                     cache))

    f_merges = {}
    if args.mine:
        f_merges = filter_merges(merges, author=args.user)
    else:
        f_merges = filter_merges(merges, assignee=args.user)
    print json.dumps(f_merges, indent=4)


if __name__ == '__main__':
    main()
