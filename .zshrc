#fortune | ponysay -b round --any-pony
#export DISABLE_TESTCONTAINERS="true"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DESKTOP_DIR="$XDG_DATA_HOME/applications"
export XDG_DOCUMENTS_DIR="$HOME/Downloads"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_MUSIC_DIR="$HOME/Downloads"
export XDG_PICTURES_DIR="$HOME/Downloads"
export XDG_PUBLICSHARE_DIR="$HOME/Downloads"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export XDG_SCREENSHOT_DIR="$HOME/Screenshots"
export XDG_TEMPLATES_DIR="$HOME/Downloads"
export XDG_VIDEOS_DIR="$HOME/Downloads"
#for zsh profiling:
#zmodload zsh/zprof
DISABLE_AUTO_UPDATE="true"

POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
[[ -f $XDG_CONFIG_HOME/p10k.zsh ]] && source $XDG_CONFIG_HOME/p10k.zsh
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# Path to your oh-my-zsh installation.
#ZSH=/usr/share/oh-my-zsh/
autoload -Uz compinit
compinit

# Clone antidote if necessary.
[[ -e ${ZDOTDIR:-~}/.antidote ]] ||  git clone https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
# Initialize antidote's dynamic mode, which changes `antidote bundle`
# from static mode.
source <(antidote init)


antidote bundle ohmyzsh/ohmyzsh
antidote bundle ohmyzsh/ohmyzsh path:lib
plugins=(git gitfast common-aliases docker-compose docker colored-man-pages fancy-ctrl-z fzf gpg-agent sudo npm nmap node)

for plugin in $plugins; do
   antidote bundle ohmyzsh/ohmyzsh path:plugins/$plugin
done
# dont work with antidote
#antidote bundle ohmyzsh/ohmyzsh path:plugins/fd/_fd
#antidote bundle ohmyzsh/ohmyzsh path:plugins/ripgrep/_ripgrep
#antidote bundle ohmyzsh/ohmyzsh path:plugins/ng/_ng
#antidote bundle ohmyzsh/ohmyzsh path:plugins/adb/_adb
antidote bundle zsh-users/zsh-completions
antidote bundle zsh-users/zsh-syntax-highlighting
antidote bundle zsh-users/zsh-autosuggestions
antidote bundle Aloxaf/fzf-tab
antidote bundle "MichaelAquilina/zsh-you-should-use"
antidote bundle romkatv/powerlevel10k

COMPLETION_WAITING_DOTS="true"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}'
zstyle ':completion:*' use-ip true

SAVEHIST=9223372036854775807
HISTSIZE=9223372036854775807
HISTFILE=${ZDOTDIR:-~}/.zsh_history

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt INC_APPEND_HISTORY
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY             # Share history between all sessions.

ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

export ZSH_COMPDUMP="${ZSH_CACHE_DIR}/.zcompdump-${ZSH_VERSION}"

zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:complete:*' fzf-bindings alt-space:toggle
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa --icons --sort=.name -ahl $realpath'

function timestamp-decode () {
  date -d "@$1"
}

function jwt-decode() {
  jq -R 'split(".") |.[0:2] | map(@base64d) | map(fromjson)' <<< $1
}

function e.() {
  xdg-open . 
}

function e() {
  xdg-open "$*" > /dev/null
}

function bak() {
  cp -r "${1%/}" "${1%/}.bak" && echo "Created Backup-File: ${1%/}.bak"
}

function enable_notifications(){
  notify-send "DUNST_COMMAND_RESUME"
}

function disable_notifications(){
  notify-send "DUNST_COMMAND_PAUSE"
}

function killport {
    lsof -i tcp:"$1" | grep LISTEN | awk '{print $2}'
}

function openPdf {
    find . -name "*.pdf" | grep -v "target" | grep -v ".idea" | fzf  --height 1% --layout=reverse |xargs evince $2
}
function gch() {
 git checkout $(git branch — all | fzf| tr -d ‘[:space:]’)
}

alias cp=cp -i
alias mv=mv -i
alias top=btop
alias v=nvim 
alias vim=nvim 
alias splitt="xfce4-terminal --default-working-directory $PWD"
alias splitt="xfce4-terminal --default-working-directory $PWD"
alias cat="bat"
alias fzf=fzf --ansi
alias ping=prettyping --nolegend
alias du=dust
alias diff=delta # better diff 
alias ls="exa --icons --sort=.name --group-directories-first"
alias la="exa --long --header --links --accessed --modified --created --group --all --sort=.name  --group-directories-first"
alias rg=rg -S
alias jq=jq -r
alias cls=clear
alias gs="git status"
alias gc="git checkout"
alias goscripts="$EDITOR \$(fd . $SCRIPTS/ | fzf)"
alias goprojects="cd \$(find ~/dev -type d -exec test -e '{}/.git' ';' -print -prune | fzf)"
alias pp="goprojects"
alias arch-wiki-manpages="awman"
alias mci="mvn clean install"
alias killAllDockerContainer="docker stop $(docker ps -q -a) && docker rm $(docker ps -q -a)"
alias currentTerm="ps -aux | grep `ps -p $$ -o ppid=` | awk 'NR==1{print $NF}'"
alias which_term=currentTerm
alias homestart="autorandr --load home"
alias su="systemctl --user"
alias ju="journalctl --user"
alias f=thefuck
eval $(thefuck --alias)
alias sl="sl | lolcat"
alias getServiceTagDell="dmidecode -t 1"
alias toclip="xclip -selection clipboard"

# Dotfile Commands
alias c='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias cs="c status"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias configHide="config update-index --assume-unchanged"
alias configUnhide="config update-index --no-assume-unchanged"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source /home/david/.config/broot/launcher/bash/br
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
#for zsh profiling too:
#zprof

