# Setup Apps as Default
export VISUAL=nvim
export EDITOR="$VISUAL"
export BROWSER="google-chrome-stable"

export SCRIPTS="$HOME/scripts"

[ -d $SCRIPTS ] && PATH="$SCRIPTS:$PATH"
skip_global_compinit=1

# fix XMonad Intellij Render Bug
export _JAVA_AWT_WM_NONREPARENTING=1

# Cleanup
export HISTFILE="$XDG_DATA_HOME"/zsh/history
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker

export EXA_COLORS="\
da=38;5;245:\
di=38;5;23:\
sn=38;5;28:\
sb=38;5;28:\
uu=38;5;40:\
un=38;5;160:\
gu=38;5;40:\
gn=38:5:160:\
bl=38;5;220:\
ur=37:\
uw=37:\
ux=37:\
ue=37:\
gr=37:\
gw=37:\
gx=37:\
tr=37:\
tw=37:\
tx=37:\
su=37:\
sf=37:\
xa=37"
