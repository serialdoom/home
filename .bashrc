function source_file {
    if [[ -f $i ]]; then
        if [ -f /tmp/verbose ]; then
            echo "sourcing $i"
            source $i
        else
            source $i &> /dev/null
        fi
    fi
}

SOURCE_LIST=(
    ~/.bashrc_alias
    ~/.bashrc_functions
    ~/.bashrc_exports
    ~/.bashrc_aws
    ~/bin/autocomplete.d/*
    /usr/share/autojump/autojump.sh
    ~/.autojump/etc/profile.d/autojump.sh 
)

SOURCE_LIST_NON_ROOT=(
    /usr/local/src/ansible/hacking/env-setup 
)

for i in "${SOURCE_LIST[@]}"; do
    source_file $i
done
if [[ $UID -ne 0 ]]; then
    for i in "${SOURCE_LIST_NON_ROOT[@]}"; do
        source_file $i
    done
fi

if [[ $- == *i* ]]; then
    [ -x ~/bin/fortune.sh ] && ~/bin/fortune.sh
fi

[[ "$(ps uxa | grep [a]wesome | wc -l)" -gt 0 ]] && setup_xdbus
