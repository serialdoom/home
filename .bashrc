[ -f ~/.bashrc_exports ] && source ~/.bashrc_exports
[ -f ~/.bashrc_functions ] && source ~/.bashrc_functions
[ -f ~/.bashrc_alias ] && source ~/.bashrc_alias

if [[ -d $HOME/bin/autocomplete.d ]]; then
    for f in $HOME/bin/autocomplete.d/*; do
        source $f
    done
fi

if [[ $- == *i* ]]; then
    [ -x ~/bin/fortune.sh ] && ~/bin/fortune.sh
fi

[[ -x $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh
[[ "$(ps uxa | grep [a]wesome | wc -l)" -gt 0 ]] && setup_xdbus
