HOME=$(readlink -f ~/)
SOURCE_LIST="$HOME/.proxy_info $HOME/.p4_setup.sh"
#case $- in
    #*i*) ENABLE_OUTPUT=1;;
#esac

for f in $SOURCE_LIST; do
    if [[ -f "$f" ]]; then
        source "$f";
    fi
done

export EDITOR="vim -X"

## python path
if [[ -d ~/tmp_install_$(hostname) ]]; then
    export PATH="~/tmp_install_$(hostname):$PATH";
else
    export PATH="/home/$USER/tmp/install_*/bin:$PATH";
fi

export PATH="~/bin:/home/$USER/tmp/install/bin:/home/$USER/tmp/p4v/bin:$PATH:/tools/bin:/home/mc42/tmp/jdk1.8.0_40/bin"
export LD_LIBRARY_PATH="$HOME/tmp/install/lib:$LD_LIBRARY_PATH" # tmux requires this
export TMPDIR=/tmp/$USER;
export MY_REPO_DIR=$HOME/tmp/install/repos/
export MY_INSTALL_DIR=$HOME/tmp/install/
HISTTIMEFORMAT="%d/%m/%y %T "

[ -d $TMPDIR ] || mkdir $TMPDIR;
chmod 700 $TMPDIR

alias v='vim -X'
alias le='less -R --ignore-case'
alias ls='ls --color=auto'
alias ll='ls --color=yes | le'
alias lt="find ./ -maxdepth 1 -printf '%T+ %p\n' | sort -r"
alias lt2="find ./ -maxdepth 2 -printf '%T+ %p\n' | sort -r"
alias lt3="find ./ -maxdepth 3 -printf '%T+ %p\n' | sort -r"
alias ..='c ../'
alias ...='c ../../'
alias ....='c ../../../'
alias .....='c ../../../../'
alias brc="$EDITOR ~/.bashrc && . ~/.bashrc"
alias vrc="$EDITOR ~/.vimrc"
alias vst='$EDITOR $(hg status -m | hg status -m | cut -d " " -f2 | tr -s "\n" " ")'
alias vsto='$EDITOR -O $(hg status -m | hg status -m | cut -d " " -f2 | tr -s "\n" " ")'
alias history_populate="history | tr -s ' ' | cut -d ' ' -f3 | sort | uniq -c | sort -rn  | head"
alias l='ls -al'
alias k='ls'
alias vtest="cd ~/tmp/ && $EDITOR $RANDOM$RANDOM.c; cd -"
alias grep='grep --color=auto'
alias df='df -h'
alias acl='ag'
alias acc='ag --cc'
alias accx='ag --cc --xml'
alias acx='ag --xml'
alias acm='ag --make'
alias acs='ag --asm'
alias ctmp='export CTMP=$(date +"%Y%m%d_%H%M%S") && cd ~/tmp/ && mkdir $CTMP && cd $CTMP'
alias h='hg'
alias tm='tmux -2'
alias forig='find ./ -name "*\.orig"'
alias fpm='find ./output -name "*pm"'
alias felf='find ./output -name "*elf"'
alias f='find'
#alias cmake="make -s RELEASE=amber_d02_off_chip_apps -C src/"
alias dl='hg cdiff | less -R'
alias rl='readlink -f'
alias tjen='tmux -2 attach-session -t jenkins'
alias hcim='hg commit -m "branch merge"'
alias ff='find . -type f -printf "%T@ %p\n" | sort -n | tail -5 | cut -f2- -d" "'
alias fff='find . -type f -printf "%T@ %p\n" | sort -n | tail -10 | cut -f2- -d" "'


LS_COLORS='di=0;35' ;
export LS_COLORS
export LESS='-R'
export LESSOPEN='|~/.lessfilter %s'

for f in $HOME/bin/autocomplete.d/*; do
    source $f
done

PROMPT_COMMAND=prompt

if [[ $- == *i* ]]; then
    [ -x ~/bin/fortune.sh ] && ~/bin/fortune.sh
fi

[[ -x /home/$USER/.autojump/etc/profile.d/autojump.sh ]] && source /home/$USER/.autojump/etc/profile.d/autojump.sh
[[ -x /home/$USER/bin/bash/autocomplete.sh ]] && source /home/$USER/bin/bash/autocomplete.sh 

#############################################
#### FUNCTIONS ##############################
#############################################

function d {
    #alias d='hg cdiff'
    local directory="$1"
    if [[ ! -e "$directory" ]]; then
        directory="."
    fi
    hg id &> /dev/null
    if [[ "$?" -eq 0 ]]; then
        hg cdiff "$directory"
        return
    fi
    p4 diff

}

function s {
    #alias s='hg st'
    local directory="$1"
    if [[ ! -d "$directory" ]]; then
        directory="."
    fi
    hg st "$directory"
}

function hgp {
    HGP_BACKUP_DIR=$HOME/.backup/patch/
    local name=""
    if [[ $1 ]]; then
        name="_$(echo $* | tr -s ' ' '_')_"
    fi
    local outfile="$(date +'%Y%m%d_%H%M%S')$name.patch"
    hg diff . > $outfile
    [[ -d $HGP_BACKUP_DIR ]] || mkdir -p $HGP_BACKUP_DIR
    cp $outfile $HGP_BACKUP_DIR;
    echo "cp $outfile $HGP_BACKUP_DIR;"
}

HISTORY_TMP=/home/$USER/.backup/.history-$(hostname).txt
function save_last_command {
    [ -f $HISTORY_TMP ] && history | tail -1 >> $HISTORY_TMP
}

function get_username_color {
    local hhash=$(whoami| md5sum | grep "[0-9]" -o | paste -s -d+ - |bc)
    local peos=$[ $hhash % 14 ]
    #echo "username $(whoami) hash $hhash peos $peos"
    case $peos in
         0) echo "\[\e[00;37m\]\u\[\e[0m\]";; ## username_white
         1) echo "\[\e[00;31m\]\u\[\e[0m\]";; ## username_red
         2) echo "\[\e[00;32m\]\u\[\e[0m\]";; ## username_green
         3) echo "\[\e[00;33m\]\u\[\e[0m\]";; ## username_yellow
         4) echo "\[\e[00;31m\]\u\[\e[0m\]";; ## username_red
         #4) echo "\[\e[00;34m\]\u\[\e[0m\]";; ## username_blue # not readable
         5) echo "\[\e[00;35m\]\u\[\e[0m\]";; ## username_purple
         6) echo "\[\e[00;35m\]\u\[\e[0m\]";; ## username_cyan
         ## bold colors
         7) echo "\[\e[01;37m\]\u\[\e[0m\]";; ## username_white
         8) echo "\[\e[01;31m\]\u\[\e[0m\]";; ## username_red
         9) echo "\[\e[01;32m\]\u\[\e[0m\]";; ## username_green
        10) echo "\[\e[01;33m\]\u\[\e[0m\]";; ## username_yellow
        11) echo "\[\e[01;31m\]\u\[\e[0m\]";; ## username_red
        #11) echo "\[\e[01;34m\]\u\[\e[0m\]";; ## username_blue # not readable
        12) echo "\[\e[01;35m\]\u\[\e[0m\]";; ## username_purple
        13) echo "\[\e[01;35m\]\u\[\e[0m\]";; ## username_cyan
    esac
}
function get_hostname_color {
    local hhash=$PROMPT_HOSTNAME_COLOR_HASH
    if [[ -z $hhash ]]; then
        hhash=$(hostname | md5sum | grep "[0-9]" -o | paste -s -d+ - |bc)
        export PROMPT_HOSTNAME_COLOR_HASH=$hhash
    fi
    local peos=$[ $hhash % 14 ]
    case $peos in
         0) echo "\[\e[00;37m\]\h\[\e[0m\]";; ## hostname_white
         1) echo "\[\e[00;31m\]\h\[\e[0m\]";; ## hostname_red
         2) echo "\[\e[00;32m\]\h\[\e[0m\]";; ## hostname_green
         3) echo "\[\e[00;33m\]\h\[\e[0m\]";; ## hostname_yellow
         4) echo "\[\e[00;31m\]\h\[\e[0m\]";; ## hostname_red
         #4) echo "\[\e[00;34m\]\h\[\e[0m\]";; ## hostname_blue # not readable
         5) echo "\[\e[00;35m\]\h\[\e[0m\]";; ## hostname_purple
         6) echo "\[\e[00;35m\]\h\[\e[0m\]";; ## hostname_cyan
         ## bold colors
         7) echo "\[\e[01;37m\]\h\[\e[0m\]";; ## hostname_white
         8) echo "\[\e[01;31m\]\h\[\e[0m\]";; ## hostname_red
         9) echo "\[\e[01;32m\]\h\[\e[0m\]";; ## hostname_green
        10) echo "\[\e[01;33m\]\h\[\e[0m\]";; ## hostname_yellow
        11) echo "\[\e[01;31m\]\h\[\e[0m\]";; ## hostname_red
        #11) echo "\[\e[01;34m\]\h\[\e[0m\]";; ## hostname_blue # not readable
        12) echo "\[\e[01;35m\]\h\[\e[0m\]";; ## hostname_purple
        13) echo "\[\e[01;35m\]\h\[\e[0m\]";; ## hostname_cyan
    esac
}

function set_prompt {
    local PROMPT_DATE="\[\033[38;5;10m\]\d\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;10m\]\t\[$(tput sgr0)\]"
    local PROMPT_USER_NAME="$(get_username_color)"
    local PROMPT_AT="\[\e[00;37m\]@\[\e[0m\]"
    local PROMPT_HOST="$(get_hostname_color)"
    local PROMPT_PATH="\[\e[00;37m\]\w\[\e[0m\]"
    local EXIT_STATUS_GOOD="\[\e[00;32m\]#\[\e[0m\]"
    local EXIT_STATUS_BAD="\[\e[00;31m\]#\[\e[0m\]"
    local prompt_text="$PROMPT_DATE\n$PROMPT_USER_NAME$PROMPT_AT$PROMPT_HOST $PROMPT_PATH"
    if [[ $1 -eq 0 ]]; then
        export PS1="$prompt_text\n$EXIT_STATUS_GOOD"
    else
        export PS1="$prompt_text\n$EXIT_STATUS_BAD"
    fi
}

function prompt {
    set_prompt $?
    save_last_command
}
function get_load {
    CPU_LOAD=$(uptime | tr -s ' ' | cut -d ' ' -f12 | tr -d ',');
}

function c () {
    [ ! $1 ] && cd ~ && ls && return 0;
    cd "$1" && ls
}

function backup {
    local name="$(date +'%Y%m%d_%H%M%S')"
    local delete=0;
    local source="";
    if [[ "$@" =~ " -d" ]]; then
        source=$(echo $@ | perl -p -i -e 's/ \-d//')
        delete=1;
    elif [[ "$@" =~ "-d " ]]; then
        source=$(echo $@ | perl -p -i -e 's/\-d/ /')
        delete=1;
    else
        source="$1";
    fi
    source=$(echo $source | perl -p -i -e 's/^\s*//' | perl -p -i -e 's/\s*$//');

    source=$(echo $source | perl -p -i -e 's!/$!!')
    if [[ $delete -eq 1 ]]; then
        echo "mv \"$source\" \"$source.$name\"";
        mv "$source" "$source.$name";
    else
        echo "cp -r \"$source\" \"$source.$name\"";
        cp -r "$source" "$source.$name";
    fi
}

function ex {                                                                      
    [ ! "$1" ] && echo "Provide an arcive name to extract";                        
    case "$1" in                                                                   
        *.zip)                                                                     
            mkdir -p $(basename "$1" .zip);                                        
            cd $(basename "$1" .zip);                                              
            cp "../$1" ./                                                          
            unzip "$1";                                                            
            ;;                                                                     
        *tar.bz2)                                                                  
            tar xvfj $1;                                                           
            ;;                                                                     
        *tar.gz|*.tgz)                                                             
            tar xvfz $1;                                                           
            ;;                                                                                                                                                                                        
        *tar)                                                                   
            tar xvf $1;                                                         
            ;;                                                                  
        *tar.lzma)                                                              
            unlzma "$1";                                                        
            tar xvf $(echo "$1" | perl -p -i -e "s/\.lzma$//");                 
            ;;                                                                  
        *gz)                                                                    
            gunzip "$1";                                                        
            ;;                                                                  
        *rar)                                                                   
            local name=$(basename "$1" .rar);                                   
            mkdir -p $name;                                                     
            cd $name;                                                           
            cp "../$1" ./;                                                      
            rar e "$1";                                                         
            ;;                                                                  
        *)                                                                      
            echo "I just dont know what do to with this $1";                    
            ;;                                                                  
    esac;                                                                       
}  

function puppet-service {
    for f in $(service --status-all | grep -oP "pe-.*"); do sudo service $f $1; done
}

function mongodb_install {
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
    sudo apt-get update
    sudo apt-get install -y mongodb-org
}

function execute_cmd {
    echo "$*"
    eval "$*"
    if [[ $? -ne 0 ]]; then
        echo "****** ERROR **********"
        return
    fi
}

function conf_make_install {
    # $1 directory to do all that
    pushd "$1"
    execute_cmd "./configure --prefix $MY_INSTALL_DIR $CONF_MAKE_INSTALL_CONFIGURE_FLAGS &> configure.log"
    execute_cmd "make -j &> make.log"
    execute_cmd "make install &> make_install.log"
    popd > /dev/null
}

function new_repo {
    # $1 repo name
    # $2 folder name
    [ -d $MY_REPO_DIR ] || mkdir -p $MY_REPO_DIR
    cd $MY_REPO_DIR
    if [[ ! -d "$2" ]]; then
        case "$1" in
            git*) git clone "$1";;
            ftp*) curl -s -U $(proxy_username):$(proxy_password) "$1" > $(basename "$1")
                  tar xf $(basename "$1");;
            http*)
                  curl -L -s -U $(proxy_username):$(proxy_password) "$1" > $(basename "$1");
                  tar xf $(basename "$1");;
            *) echo "Dont know what do do with [$1]";;
        esac
    fi
    pwd
    cd "$2"
}

function proxy_username {
    echo $(grep -oP "USER.*" ~/.proxy | cut -d '=' -f2)
}
function proxy_password {
    echo $(grep -oP "PASSWORD.*" ~/.proxy | cut -d '=' -f2)
}

function tmux {
    if [[ -x $MY_INSTALL_DIR/bin/tmux ]]; then
        $(which tmux) $*
        return;
    fi
    new_repo git@github.com:ThomasAdam/tmux.git tmux
    libevent
    sh autogen.sh
    (
        export CONF_MAKE_INSTALL_CONFIGURE_FLAGS="CFLAGS=\"-I$MY_INSTALL_DIR/include/\" LDFLAGS=\"-L$MY_INSTALL_DIR/lib\""
        #export LD_LIBRARY_PRELOAD="$MY_INSTALL_DIR/lib"
        conf_make_install .
    )
}

function libevent {
    [ -f $MY_INSTALL_DIR/lib/libevent.a ] && return
    pushd . > /dev/null
    local lib_url=$(curl -U mc42:tsoutsouni.42 "http://libevent.org/" -s | grep -o "http.*stable.tar.gz\"" | head -1 | tr -d '"')
    echo "new_repo $lib_url $(basename $lib_url .tar.gz)"
    new_repo $lib_url $(basename $lib_url .tar.gz)
    conf_make_install .
    rm -rf libevent.*stable.tar.gz
    popd > /dev/null
}
    
function ag {
    if [[ -x $MY_INSTALL_DIR/bin/ag ]]; then
        $(which ag) $* --pager="less -XF"
        return
    fi
    new_repo git@github.com:ggreer/the_silver_searcher.git the_silver_searcher
    pcre # depends on 
    (
        execute_cmd "PKG_CONFIG_PATH=$MY_INSTALL_DIR/lib/pkgconfig ./build.sh --prefix $MY_INSTALL_DIR &> build.log"
        execute_cmd "make install &> make_install.log"
    )
}

function pcre {
    [ -x $MY_INSTALL_DIR/bin/pcregrep ] && return;
    pushd .
    local pcre=$(curl -U $(proxy_username):$(proxy_password) "http://www.linuxfromscratch.org/blfs/view/svn/general/pcre.html" -s | grep -oP "ftp.*tar.bz2" | head -1)
    new_repo $pcre $(basename $pcre .tar.bz2)
    conf_make_install .
    rm -rf pcre*tar.bz2
    popd
}

function github_setup {
    if [[ ! -d $HOME/.ssh ]]; then
        mkdir -p $HOME/.ssh
        chmod 700 $HOME/.ssh
    fi
    local id_file="$HOME/.ssh/${USER}__$(hostname)__to_github"
    local cmd="ssh-keygen -f $id_file -t rsa -b $[ 8 * 1024 ] -N \"\""
    eval $cmd
    if [[ ! -f $id_file ]]; then
        echo "Error, cannot find private key [$cmd]"
        ls -al  $id_file
        return;
    fi
    if [[ ! -f ${id_file}.pub ]]; then
        echo "Error, cannot fild pub key [$cmd]"
        return;
    fi
    echo -e "\nHost github.com\n\t##autogenerated\n\tIdentityFile $id_file\n" >> ~/.ssh/config
    cat ${id_file}.pub
}

function pcalc {
    [ -x $(which pcalc) ] && $(which pcalc) $*
    [ -d $MY_REPO_DIR ] || mkdir -p $MY_REPO_DIR
    cd $MY_REPO_DIR;
    [ -d pcalc ] || git clone git@github.com:serialdoom/pcalc.git
    cd pcalc
    make -j
    cp pcalc $MY_INSTALL_DIR/bin/
}
