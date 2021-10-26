# Setup Apps as Default
export VISUAL=nvim
export EDITOR="$VISUAL"
export BROWSER="google-chrome-stable"

export SCRIPTS="$HOME/scripts"

[ -d $SCRIPTS ] && PATH="$SCRIPTS:$PATH"
skip_global_compinit=1

# Cleanup
export HISTFILE="$XDG_DATA_HOME"/zsh/history
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
