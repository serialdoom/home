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
    ~/.repo/pyvmomi-scripts/.vsphere_autocomplete.sh
    /usr/share/bash-completion/completions/ssh
)

SOURCE_LIST_NON_ROOT=(
    ~/.repo/ansible/hacking/env-setup
)

for i in "${SOURCE_LIST[@]}"; do
    [ -f ] && source_file $i
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

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    :
else
    if [[ "$(xrandr -q | grep -P "\bconnected\b" -c)" -eq 2 ]]; then
        xrandr --output DP1 --right-of DP2
    fi
fi

if [[ ! -d ~/.fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [[ ! -f ~/.git-prompt.sh ]]; then
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh > ~/.git-prompt.sh
    chmod +x ~/.git-prompt.sh
fi
source ~/.git-prompt.sh
