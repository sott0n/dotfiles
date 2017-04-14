# ====================================
# .zshrc
# ====================================

# ------------------------------------
# Completion
# ------------------------------------
fpath=(/usr/local/share/zsh/functions ${fpath})
autoload -U compinit && compinit

# Asking
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:default' menu select=1

# Compacked complete list display
setopt list_packed

# Coloring complete list display
zstyle ':completion:*' list-colors ''

# ------------------------------------
# Command History
# ------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# Ignore duplication command history list
setopt hist_ignore_dups

# Share command history data
setopt share_history

# Historical backward/forward search
# with linehead string binded to ^P/^N
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# ------------------------------------
# Key bind (emacs)
# ------------------------------------
bindkey -e

# ------------------------------------
# cd
# ------------------------------------
setopt auto_cd

# Auto directory pushd
# that you can get dirs list by cd -[tab]
setopt auto_pushd

# ------------------------------------
# Correct miss typing command
# ------------------------------------
setopt correct

# ------------------------------------
# Prompt
# ------------------------------------
setopt prompt_subst
setopt prompt_percent
setopt transient_rprompt

autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'

_vcs_precmd () { vcs_info }

autoload -Uz add-zsh-hook
add-zsh-hook precmd _vcs_precmd 
PROMPT='%~ %F{yellow}${vcs_info_msg_0_}%f
🍻  '
RPROMPT=''

# ------------------------------------
# Read settings
# ------------------------------------
[ -f ~/.dotfiles/zsh/global    ] && source ~/.dotfiles/zsh/global
[ -f ~/.dotfiles/zsh/alias     ] && source ~/.dotfiles/zsh/alias
[ -f ~/.dotfiles/zsh/functions ] && source ~/.dotfiles/zsh/functions
[ -f ~/.dotfiles/zsh/helper/docker      ] && source ~/.dotfiles/zsh/helper/docker
[ -f ~/.dotfiles/zsh/helper/http_status ] && source ~/.dotfiles/zsh/helper/http_status

# ------------------------------------
# Read local settings
# ------------------------------------
[ -f ~/.local-dotfiles/zshrc ] && source ~/.local-dotfiles/zshrc

# ------------------------------------
# Read OS specific settings
# ------------------------------------
case "${OSTYPE}" in
    darwin*)
	  [ -f ~/.dotfiles/zsh/os/darwin ] && source ~/.dotfiles/zsh/os/darwin
	;;

    linux*)
	  [ -f ~/.dotfiles/zsh/os/linux ] && source ~/.dotfiles/zsh/os/linux
	;;
esac


# ------------------------------------
# PATH
# ------------------------------------
export PATH="/Users/nojo/anaconda/bin:$PATH"
export PATH="/Applications/Racket v6.8/bin/racket:$PATH"

#------------------------------------
# Environment
# ------------------------------------
alias py3='source activate py33con'
alias py2='source deactivate'

# ------------------------------------
# General
# ------------------------------------
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'
alias df='df -h'
alias du='du -h'
alias lv8='lv -Ou8'
alias ag='ag --ignore-dir vendor'
alias ls='/usr/local/bin/gls --color=auto'
alias ll='ls -l'
alias excel='cat ~/workspace/tool/vim/excel_cheetsheat.md'
alias sss='source /Users/nojo/dotfiles/.zshrc'

# ------------------------------------
# Git
# ------------------------------------
alias gs='git status'
alias au='git add -u; git status'
alias gm='git checkout master'
alias gp='git push'
alias tt='tig'
alias gb='git branch'
