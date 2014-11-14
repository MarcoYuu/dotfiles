#
# Bourne Again SHell init file.
#
#
umask 022
ulimit -c 0

if [ "x$COLORFGBG" != "x" ]; then
	unset COLORFGBG
fi
if [ "x$COLORTERM" != "x" ]; then
	unset COLORTERM
fi
if [ "TERM" != "screen" ]; then
	TERM=xterm
fi
if [ "$TERM" == "xterm" ]; then
	#export TERM=xterm-256color
	export TERM=screen-256color
fi

#git用
if [ -f ~/.git-completion.bash ]; then
	. ~/.git-completion.bash
fi

# If running interactively, then:
if [ "$PS1" ]; then
	set -o ignoreeof
	set -o notify
	set -o noclobber

	FIGNORE='.c~:.h~:.tex~:.ps~:.sty~:.aux:.lot:.lof:.toc'

	if [ ! "$LOGIN_SHELL" ]; then
		PS1="\033[7m \u[\h:\w] \033[m\n\!> "
	fi

	HISTSIZE=200
	MAILCHECK=60
fi
export LANG=ja_JP.UTF-8

if [ -f .bash_aliases ]; then
	source .bash_aliases
fi

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then

	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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



# --------------------------------------------------------------------------------
# ここより下は各自
# --------------------------------------------------------------------------------
# ------------- PATH --------------
export PATH=~/bin:/usr/local/bin:${PATH}
export PATH=${PATH}:/opt/android-studio/sdk/platform-tools:/opt/android-studio/sdk/tools

# -------------- aliases --------------
alias ls='ls -vpF --color=auto --group-directories-first'
alias ll='ls -alF'
alias la='ls -AF'
alias l='ls -CF'
alias diff=colordiff
alias pd=pushd
alias bd=popd


# -------------- functions --------------
cdls() {
	if [ -z "$1" ]; then
		\cd;
		ls;
	elif [ -z "$2" ]; then
		\cd $1;
		ls;
	else
		\pushd $1;
		ls;
	fi
}

# man color view
export MANPAGER='less -R'
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
		man "$@"
}

csv_view() {
	if [ -p /dev/stdin ]; then
		column -s, -t </dev/stdin | lv -c
	elif [ -z "$1" ]; then
		echo "no file specified."
	else
		column -s, -t < $1 | lv
	fi
}
alias tless='csv_view()'


# -------------- 開発系 -------------------
# ruby env
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# pyclewn
# alias gdbvim='pyclewn -e vim --gdb=async --args'
alias gdbvim='pyclewn -e vim --args'
export PYTHONPATH=$HOME/lib/python:$PYTHONPATH

# for pretty gdb
export PYTHONPATH=$HOME/bin/gdb/python:$PYTHONPATH
export PYTHONPATH=$HOME/bin/gdb/Boost-Pretty-Printer:$PYTHONPATH

# make のデフォオプション
export MAKEOPTS=-j4

# gcc切り替え
alias switchgcc='sudo update-alternatives --config gcc'

# vim キーバインド用
stty -ixon -ixoff

# ※とかを普通に表示させる
export VTE_CJK_WIDTH=auto

# emacsのなんか
alias emacs='XMODIFIERS=@im=none emacs'

# -------------- プロンプト表示 -------------------
# Gitブランチ表示
source ~/bin/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
export PS1='\[\033[1;32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ \n>'

# tmux用
PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'

