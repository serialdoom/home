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
    ~/.bash/alias
    ~/.bash/alias.$(uname)
    ~/.bash/functions
    ~/.bash/exports
    ~/.bash/aws
    ~/bin/autocomplete.d/*
    /usr/share/autojump/autojump.sh
    ~/.autojump/etc/profile.d/autojump.sh
    ~/.local/etc/profile.d/autojump.sh
    ~/.repo/pyvmomi-scripts/.vsphere_autocomplete.sh
    /usr/share/bash-completion/completions/ssh
    ~/.fzf.bash
    ~/.git-prompt.sh
    /etc/bash_completion.d/git-prompt
    /etc/bash_completion
    ~/.bash/vagrant_autocomplete.sh
    ~/.bash/make_autocomplete.sh
)

SOURCE_LIST_NON_ROOT=(
    ~/.repo/ansible/hacking/env-setup
)


[ ! -f ~/.bash/make_autocomplete.sh ] && wget https://raw.githubusercontent.com/scop/bash-completion/master/completions/make -o ~/.bash/make_autocomplete.sh

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
elif [[ "$(uname)" == 'Linux' ]] && [[ "$(xrandr -q | grep -P "\bconnected\b" -c)" -eq 2 ]]; then
        xrandr --output DP1 --right-of DP2
fi

if [[ ! -d ~/.fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi

if [[ -f ~/.bashrc_local ]]; then
    source ~/.bashrc_local
fi
