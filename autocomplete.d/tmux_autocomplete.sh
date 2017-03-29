
TMUX_COMPLETE="$TMPDIR/tmux_complete_options"

if [[ ! -f $TMUX_COMPLETE ]]; then
    # try the man pages
    man tmux > $TMUX_COMPLETE
    if [[ $? -ne 0 ]]; then
        [[ ! -f /home/mc42/bin/bash/man_tmux.txt  ]] && return
    fi

    cat $TMUX_COMPLETE | strings | grep "[[:alpha:]]+-[[:alpha:]]+" -oP | sort -u > ${TMUX_COMPLETE}.sorted
    mv $TMUX_COMPLETE.sorted $TMUX_COMPLETE
fi

function _tmux_complete_()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(cat $TMUX_COMPLETE);

	case "${prev}" in
		attach-session)
			local args="-t"
			COMPREPLY=( $(compgen -W "${sessions}" -- ${cur}) )
			COMPREPLY=( "-t" )
			return 0;
			;;
		-t)
			local sessions=$(tmux ls | cut -d ":" -f 1);
			COMPREPLY=( $(compgen -W "${sessions}" -- ${cur}) )
			return 0
			;;
	esac
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )

    return 0
}

complete -F _tmux_complete_ tmux

