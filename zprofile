# vim: ft=zsh

if [ -x "$(which luarocks)" ]; then
	eval $(luarocks path)
fi

if [ -z "$SSH_AGENT_PID" ]; then
	eval $(ssh-agent)
fi


export BSPWM_SOCKET="$HOME/tmp/bspwm-socket"
export EDITOR=vim
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
	"$HOME/.luarocks/bin"
	"$HOME/.nix-profile/bin"
	"$HOME/go/bin"
	"$HOME/opt/VSCode-linux-x64/bin"
	"$HOME/opt/dmd2/bin"
	"$HOME/opt/dotnet-sdk"
	"$HOME/opt/nvim-linux64/bin"
	"$HOME/opt/zig-linux-x86_64"
	"$HOME/opt/platform-tools"
	"$HOME/opt/omnisharp.http-linux/bin"
	"$HOME/usr/bin"
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

