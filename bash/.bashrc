# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=500000
HISTFILESIZE=5000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
export LESSCHARSET="utf-8"
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/
alias screen="screen -U"
export PATH="/www/haddop/conf:$PATH"
export PIG_CLASSPATH="/www/hadoop/conf/"
export SPARK_HOME=/usr/local/spark

# Libraries for python
export LD_LIBRARY_PATH=/home/alan/local/lib/:$LD_LIBRARY_PATH

# bash_prompt

# Example:
# nicolas@host: ~/.dotfiles on master [+!?$]
# $

# Screenshot: http://i.imgur.com/DSJ1G.png
# iTerm2 prefs: import Solarized theme (disable bright colors for bold text)
# Color ref: http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim
# More tips: http://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html

prompt_git() {
    local s=""
    local branchName=""

    # check if the current directory is in a git repository
    if [ $(git rev-parse --is-inside-work-tree &>/dev/null; printf "%s" $?) == 0 ]; then

        # check if the current directory is in .git before running git checks
        if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == "false" ]; then

            # ensure index is up to date
            git update-index --really-refresh  -q &>/dev/null

            # check for uncommitted changes in the index
            if ! $(git diff --quiet --ignore-submodules --cached); then
                s="${s}m";
            fi

            # check for unstaged changes
            if ! $(git diff-files --quiet --ignore-submodules --); then
                s="${s}m";
            fi

            # check for stashed files
            if $(git rev-parse --verify refs/stash &>/dev/null); then
                s="${s}s";

            # check for untracked files
            if [ -n "$(git ls-files --others --exclude-standard)" ]; then
                s="$s?";
            fi
            fi

        fi

        # get the short symbolic ref
        # if HEAD isn't a symbolic ref, get the short SHA
        # otherwise, just give up
        branchName="$(git rev-parse --abbrev-ref HEAD)"
        #branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
        #              git rev-parse --short HEAD 2> /dev/null || \
        #              printf "(unknown)")"

        [ -n "$s" ] && s=" [$s]"

        printf "%s" "$1$branchName$s"
    else
        return
    fi
}

set_prompts() {
    local black=""
    local blue=""
    local bold=""
    local cyan=""
    local green=""
    local orange=""
    local purple=""
    local red=""
    local reset=""
    local white=""
    local yellow=""

    local hostStyle=""
    local userStyle=""

        bold=""
        reset="\e[0m"

        black="\e[1;30m"
        blue="\e[1;34m"
        cyan="\e[1;36m"
        green="\e[1;32m"
        orange="\e[1;33m"
        purple="\e[1;35m"
        red="\e[1;31m"
        white="\e[1;37m"
        yellow="\e[1;33m"

    # build the prompt

    # logged in as root
    if [[ "$USER" == "root" ]]; then
        userStyle="$bold$red"
    else
        userStyle="$orange"
    fi

    # connected via ssh
    if [[ "$SSH_TTY" ]]; then
        hostStyle="$bold$red"
    else
        hostStyle="$yellow"
    fi

    # set the terminal title to the current working directory
    PS1="\[\033]0;\w\007\]"

    PS1+="\n" # newline
    #PS1+="[\t]:"
    PS1+="\[$userStyle\]\u" # username
    PS1+="\[$reset$white\]@"
    PS1+="\[$hostStyle\]\h" # host
    PS1+="\[$reset$white\]: "
    PS1+="\[$green\]\w" # working directory
    PS1+="\$(prompt_git \"$white on $cyan\")" # git repository details
    PS1+="\n"
    PS1+="\[$reset$white\]\$ \[$reset\]" # $ (and reset color)
    export PS1
}

set_prompts
unset set_prompts

# aliases
alias ll='ls -lah --group-directories-first'
alias lt='ls -ltrah'
alias l='less -S'
alias g='grep --color=auto'
alias gr='grep -r --include'
alias lc='wc -l'
alias h='head -n'
alias f='find . -name'
alias v='vim -p'
alias vi='vim -p'

alias gs='git status'
alias gc='/home/alan/bin/mycommit.sh'
alias gps='git push origin'
alias gpl='git pull --rebase origin'
alias gf='git fetch'
alias gch='git checkout'
alias gd='git diff'
alias gm='git merge'
alias gl='git log'

alias srtu='uniq | sort | uniq'
alias srtuc='sort | uniq -c'
alias srtulc=' sort | uniq | lc'

alias cdkb='cd /www/data/knowledgebase'
alias cdf='cd /www/private/alan/fulltext/'
alias cdg='cd /www/private/alan/research/'
alias cdu='cd /www/private/alan/research/utils'
alias cdc='cd /www/private/alan/research/common'
export LC_ALL=en_US.UTF-8
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

export PATH="/home/alan/.pyenv/bin:$PATH"
# Fix highlight in less in tmux
TERM=xterm; export TERM

# Ctrl arrow skip words
bind '"\e[1;5D" backward-word' 
bind '"\e[1;5C" forward-word'
bind '"\eOC":forward-word'
bind '"\eOD":backward-word'

# added by Miniconda3 installer
#export PATH="/home/alan/miniconda3/bin:$PATH"
# . /home/alan/miniconda3/etc/profile.d/conda.sh  # commented out by conda initialize  # commented out by conda initialize


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/alan/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/alan/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/alan/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/alan/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# HSTR configuration - add this to ~/.bashrc
alias hh=hstr                    # hh to be alias for hstr
export HSTR_CONFIG=hicolor,raw-history-view       # get more colors
shopt -s histappend              # append new history items to .bash_history
#export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=100000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
# ensure synchronization between Bash memory and history file
#export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
export PROMPT_COMMAND=""
# if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
#if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
# if this is interactive shell, then bind 'kill last command' to Ctrl-x k
#if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
