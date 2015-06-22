#!/usr/bin/env bash

# install geeknote with the following steps
# 1. git clone the repo with
#   git clone git@github.com:VitaliyRodnenko/geeknote.git
# 2. get your python path from 
#   python -c "import site; print site.getsitepackages()"
# 3. then, install with
#   PYTHONPATH=/usr/lib/python2.7/dist-packages python setup.py install --user
# 4. and then run with
#   .local/bin/geeknote 

GEEKNOTE=.local/bin/geeknote 
TMP_FILE=/tmp/$(whoami)/$(basename $0).$(date '+%s')
[[ ! -x $GEEKNOTE ]] && {
    echo "Error, geeknote executable is not found"
    exit 1
}
[[ -d $(dirname $TMP_FILE) ]] || mkdir -p $(dirname $TMP_FILE)

if [[ ! "--title" =~ "$@" ]]; then
    TITLE="--title \"$@\""
else
    TITLE=""
fi

eval "$@ 2>&1 | tee $TMP_FILE"
.local/bin/geeknote create --notebook $(hostname) --title "test" --tags "$(echo "$@" | sed -r "s'[[:blank:]]+','g")" --content "$(cat $TMP_FILE)"
