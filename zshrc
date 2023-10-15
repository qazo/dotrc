# vim: ft=zsh
# autoload
autoload -Uz compinit && compinit
autoload -Uz vcs_info


# history
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# set nice prompt
if [ $UID -eq 0 ]; then
	PROMPT='%F{red}%n%f %~# '
	RPROMPT='%?'
else
	if [ -n "$SSH_CONNECTION" ]; then
		PROMPT='%F{%(?.yellow.red)}%~%f%B:%b '
	else
		PROMPT='%F{%(?.blue.red)}%~%f%B:%b '
	fi
	RPROMPT='$vcs_info_msg_0_%(?.. %F{red}%?%f)'
	PS2="%B:%b "
fi

# zstyle
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' actionformats '%F{blue}%b%F{white}:%f%F{yellow}%a%f'
zstyle ':vcs_info:*' formats '%F{blue}%r%f:%F{blue}%b%f'



autoload -Uz compinit
compinit
# End of lines added by compinstall

# bindkeys
bindkey -e
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# setopt
setopt autocd
setopt completealiases
setopt correct
setopt extendedglob
setopt histignorealldups
setopt histignoredups
setopt histignorespace
setopt histsavenodups
setopt incappendhistory
setopt interactivecomments
setopt prompt_subst
setopt pushdignoredups

# alias
alias :q='exit'
alias c='clear'
alias cls='clear'
alias cp_p='rsync --archive --partial --progress'
alias cv='clear && /bin/vdir ${=LS_OPTIONS}'
alias dict='sdcv'
alias emacs='emacs -nw'
alias j='jobs'
alias ls='/bin/ls ${=LS_OPTIONS}'
alias md='/bin/mkdir --parents'
alias mkdir='/bin/mkdir --parents'
alias mv_p='rsync -aP --remove-source-files'
alias path='echo -e ${PATH//:/\\n}'
alias grep="grep --colour=auto"
alias psgrep='ps aux | grep'
alias v='/bin/vdir ${=LS_OPTIONS}'
alias vdir='/bin/vdir ${=LS_OPTIONS}'
alias vi='vim'
alias wine64='WINEPREFIX=$HOME/.wine64 WINEARCH=win64 wine64'
alias rg='rg --color always'

# setup for the {run-,}help command
unalias run-help 2> /dev/null
autoload -Uz run-help
alias help='run-help'


if [[ $UID != 0 ]] ; then
	alias upgradepkg='sudo /sbin/upgradepkg'
	alias installpkg='sudo /sbin/installpkg'
	alias removepkg='sudo /sbin/removepkg'
fi


# directoies for quick cd
hash -d logs=/var/log
hash -d cblt=/mnt/cobalt-ss
hash -d win-c=/mnt/c
hash -d win-d=/mnt/d
hash -d win-home=/mnt/c/Users/kwezi
#hash -d wine=/media/wine/win32
#hash -d slackbuilds=/media/pkgs/_slackbuilds

# compdef
# compdef _gnu_generic mpv
compdef _gnu_generic encfs
compdef _gnu_generic aria2c
compdef _gnu_generic ifstat
compdef _gnu_generic sxiv
compdef _gnu_generic htop
compdef _gnu_generic createuser dropuser createdb dropdb initdb psql
compdef _gnu_generic ffcast
compdef _gnu_generic rg
compdef _gnu_generic myloader mydumper
compdef _gnu_generic sqlcmd

# functions
precmd() {
	vcs_info
}

function mktouch() {
	mkdir "$(dirname ${1})";
	touch ${1};
}

function tailog() {
	if [[ $UID != 0 ]]; then
		sudo tail -F ~logs/messages
	else
		tail -F ~logs/messages
	fi
}

function cnd() {
	if [[ -z $1 ]]; then
		return
	else
		mkdir -p $1
		cd $1
	fi
}

function ffconvert() {
	for file in "$@"; do
		outfile="ffconvert-out.${file}"
		ffmpeg -i "${file}" \
		   -hide_banner \
		   -codec:video libx264 \
		   -codec:audio copy \
		   -crf ${ff_crf:-27} \
		   -filter:v "scale=-2:${ff_height:-480}" \
		   ${outfile}
	done
}

function pushnd() {
	if [[ -z $1 ]]; then
		return
	else
		mkdir -p $1
		pushd $1
	fi
}

function viman() {
	vim -c "Man $1 $2 | silent only"
}

function command_not_found_handler() {
	if [ -x /usr/lib/command-not-found ]; then
		/usr/lib/command-not-found -- "$1"
		return $?
	elif [ -x /usr/share/command-not-found/command-not-found ]; then
		/usr/share/command-not-found/command-not-found -- "$1"
		return $?
	else
		printf "%s command not found\n" "$1" >&2
		return 127
	fi
}

compdef _man viman

local PLUGIN_DIR=/usr/share/zsh/plugins
[ -f ${PLUGIN_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh] && source ${PLUGIN_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh
if [ -e /home/qazo/.nix-profile/etc/profile.d/nix.sh ]; then . /home/qazo/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
