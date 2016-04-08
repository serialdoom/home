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
[ -f ~/.git-prompt.sh ] && source ~/.git-prompt.sh
[ -f /etc/bash_completion.d/git-prompt ] && source /etc/bash_completion.d/git-prompt
[ -f /etc/bash_completion ] && source /etc/bash_completion
