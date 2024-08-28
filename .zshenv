# Setup Apps as Default
export VISUAL=nvim
export EDITOR="$VISUAL"
export BROWSER="google-chrome-stable"
export PAGER=less
export SCRIPTS="$HOME/scripts"

export FZF_ALT_C_COMMAND='fd -t d --hidden'
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"
export FZF_CTRL_T_COMMAND='fd -t f --hidden'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --pager=$PAGER -p {}'"

[ -d $SCRIPTS ] && PATH="$SCRIPTS:$PATH"
skip_global_compinit=1

# fix XMonad Intellij Render Bug
export _JAVA_AWT_WM_NONREPARENTING=1

export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
export GDK_SCALE=1
export GDK_DPI_SCALE=1
export QT_QPA_PLATFORMTHEME=qt5ct
export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock

# force GTK Theme
export GTK_THEME=Adwaita:dark
export ADW_DISABLE_PORTAL=1
export ADW_DEBUG_COLOR_SCHEME=prefer-dark
