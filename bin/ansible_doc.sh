#! /usr/bin/env bash
#
# Distributed under terms of the MIT license.
#

PATH=$PATH:/usr/local/bin
CACHE=/tmp/ansible-doc/cache
LOG=/tmp/ansible-doc/

[[ -d $LOG ]] || mkdir -p $LOG

function log {
    echo "$(date) $*" >> $LOG/log
}

function exec {
    log "$@"
    eval "$@"
}


function main {
    log "arguments are $*"
    query=$1
    if [[ -z $query ]]; then
        query=$(pbpaste | tr -d ':')
    fi

    log "query is $query"
    cache_file="$CACHE/$(hash_query "$query")"
    if [[ -f $cache_file ]]; then
        echo "getting url from cache file $cache_file"
        url="$(cat "$cache_file")"
    else
        url=$(exec "googler \"ansible module $query\" --json -n 1 | jq .[0].url")
    fi
    log "Url is $url"
    trim_url="$(echo "$url" | tr -d '"')"
    log "Trimmed url [$trim_url]"
    /usr/bin/open -a "/Applications/Google Chrome.app" "$trim_url#options"
    [[ ! -f $cache_file ]] && update_cache "$query" "$trim_url"
}

function hash_query {
    echo "$1" | md5sum | cut -d ' ' -f1
}

function update_cache {
    local query=$1
    local url=$2

    [ -d $CACHE ] || mkdir -p $CACHE
    echo "$url" > "$CACHE/$(hash_query "$query")"
}

############################
main "$@"
