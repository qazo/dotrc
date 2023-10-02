# vim: ft=zsh

if [ -x "$(which luarocks)" ]; then
	echo "• luarocks"
	eval $(luarocks path)
fi

if [ -z "$SSH_AGENT_PID" ]; then
	echo "• ssh-agent"
	eval $(ssh-agent |grep SSH_)
	trap 'test -n "$SSH_AUTH_SOCK" && eval `/usr/bin/ssh-agent -k`' 0
fi


export LS_OPTIONS=--color
export BSPWM_SOCKET="$HOME/tmp/bspwm-socket"
export EDITOR=nvim
export GOPATH="$HOME/go"
export GREP_COLORS="ms=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36"
export LESS=' -R'
export LESSOPEN='| /usr/bin/src-hilite-lesspipe.sh %s'
export PGPASSFILE="$HOME/.config/postgres/pgpass"
export WINEARCH="win32"
export XDG_CONFIG_HOME="$HOME/.config"
export DOTNET_CLI_TELEMETRY_OPTOUT=1

new_dirs=(
	"/sbin"
	"/usr/sbin"
	"$HOME/.local/bin"
	"$HOME/.dotnet/tools"
	"$HOME/.gem/ruby/2.7.0/bin"
	"$HOME/bin"
	"$HOME/.luarocks/bin"
	"$HOME/.nix-profile/bin"
	"$HOME/go/bin"
	"$HOME/opt/vs-code/bin"
	"$HOME/opt/go/bin"
	"$HOME/opt/dotnet-sdk"
	"$HOME/opt/android-sdk/platform-tools"
	"$HOME/opt/flutter/bin"
	"$HOME/opt/nvim/bin"
	"$HOME/opt/zig"
	"$HOME/opt/helix"
	"$HOME/opt/platform-tools"
	"$HOME/usr/bin"
	"$HOME/opt/zls/bin"
	"$HOME/opt/omnisharp"
	"$HOME/usr/games/numptyphysics/usr/bin"
)

tmp_dirs=${PATH//:/\\n}
for dir in "${new_dirs[@]}" ; do
	if [[ -d $dir  && -z $(echo $tmp_dirs | grep -x $dir) ]]; then
		PATH+=:$dir
	fi
done
export PATH

new_dirs=(
	"$HOME/.local/man"
	"$HOME/.nix-profile/share/man"
	"$HOME/usr/man"
	"$HOME/usr/share/man"
	"$HOME/opt/nvim-linux64/share/man"
)
tmp_dirs=${MANPATH//:/\\n}
for dir in "${new_dirs[@]}" ; do
	if [[ -d $dir && -z $(echo $tmp_dirs | grep -x $dir) ]]; then
		MANPATH+=:$dir
	fi
done
export MANPATH
unset new_dirs tmp_dirs dir

