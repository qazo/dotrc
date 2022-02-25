# vim: ft=zsh

# if [ -z "$SSH_AGENT_PID" ]; then
# 	eval $(ssh-agent)
# fi

if [ -x "$(command -v luarocks)" ]; then
	eval $(luarocks path)
fi

# cd by typing dirname only
shopt -s autocd
shopt -s globstar

alias c='clear'
alias cls='clear'
alias v='ls -l'
alias cv='clear && ls -l'
alias md='mkdir -p'
alias path='echo -e ${PATH//:/\\n}'
alias :q='exit'
alias :x='exit'
alias :wq='exit'
alias make=mingw32-make
alias ssh='/c/Windows/System32/OpenSSH/ssh.exe'
alias ssh-add='/c/Windows/System32/OpenSSH/ssh-add.exe'
alias ssh-keygen='/c/Windows/System32/OpenSSH/ssh-keygen.exe'
alias scp='/c/Windows/System32/OpenSSH/scp.exe'

export PS1='\e[32m\u\e[0m:\e[34m\W\e[0m$(__git_ps1)\$ '
export PROMPT_DIRTRIM=2
export HISTCONTROL=ignorespace:erasedups

function cnd() {
	mkdir -p ${1} && cd ${1}
}

function pushnd() {
	if [[ -z $1 ]]; then
		return
	else
		mkdir -p $1
		pushd $1
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
