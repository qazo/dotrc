# vim: ft=zsh

if [ -x "$(which luarocks)" ]; then
	echo "• luarocks"
	eval "$(luarocks path)"
fi

if [ -z "$SSH_AGENT_PID" ]; then
	echo "• ssh-agent"
	eval "$(ssh-agent |grep SSH_)"
	trap 'test -n "$SSH_AUTH_SOCK" && eval "$(/usr/bin/ssh-agent -k)"' 0
fi


export ANDROID_HOME="$HOME/opt/android-sdk"
export BSPWM_SOCKET="$HOME/tmp/bspwm-socket"
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export EDITOR=nvim
export GOPATH="$HOME/go"
export GREP_COLORS="ms=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36"
export LESS=' -R'
export LESSOPEN='| /usr/bin/src-hilite-lesspipe.sh %s'
export LS_OPTIONS=--color
export PGPASSFILE="$HOME/.config/postgres/pgpass"
export XDG_CONFIG_HOME="$HOME/.config"

typeset -U path manpath

new_dirs=(
	"$HOME/.cargo/bin"
	"$HOME/.dotnet/tools"
	"$HOME/.local/bin"
	"$HOME/.luarocks/bin"
	"$HOME/.nix-profile/bin"
	"$HOME/bin"
	"$HOME/go/bin"
	"$HOME/opt/android-sdk/platform-tools"
	"$HOME/opt/dotnet-sdk"
	"$HOME/opt/flutter/bin"
	"$HOME/opt/go/bin"
	"$HOME/opt/helix"
	"$HOME/opt/node/bin"
	"$HOME/opt/nvim/bin"
	"$HOME/opt/omnisharp"
	"$HOME/opt/vscode/bin"
	"$HOME/opt/zig"
	"$HOME/opt/zls/bin"
	"$HOME/opt/numptyphysics/usr/bin"
)
for dir in "${new_dirs[@]}"; do
	[[ -d "$dir" ]] && path+=("$dir")
done

new_dirs=(
	"$HOME/.local/man"
	"$HOME/.nix-profile/share/man"
	"$HOME/opt/nvim/share/man"
	"$HOME/usr/man"
	"$HOME/usr/share/man"
)
for dir in "${new_dirs[@]}"; do
	[[ -d "$dir" ]] && manpath+=("$dir")
done

export path
export manpath
unset new_dirs dir

