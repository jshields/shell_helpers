# completions init
autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit
# terraform -install-autocomplete
complete -o nospace -C /usr/local/bin/terraform terraform


# Git branch info in prompt
# Load version control information
# https://zsh.sourceforge.io/Doc/Release/Functions.html
autoload -Uz vcs_info
precmd() { vcs_info }
# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '(%b)'

# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
setopt PROMPT_SUBST
# PROMPT='%F{red}$%f '
# PROMPT='%F{green}%*%f %F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '
# 215 = pale orange color
# https://en.wikipedia.org/wiki/ANSI_escape_code
PROMPT='%F{yellow}%~%f%F{215}${vcs_info_msg_0_}%f🥭%F{yellow}〉%f'

# TODO: set window title for zsh
# on MacOS iTerm2, configure this via Settings > Profiles > General > Title
#PS1="\[\e]2;\w\a\]$PS1"

export GOPATH=$HOME/workspace/go
export PYENV_ROOT="$HOME/.pyenv"

export PATH=~/bin:~/.local/bin:$PYENV_ROOT/bin:/opt/homebrew/bin:$GOPATH/bin:$PATH

#PATH hygiene
# - You can avoid duplicate PATH entries by using zsh’s path array:
#    - typeset -U path then set path=(~/bin ~/.local/bin $PYENV_ROOT/bin /opt/homebrew/bin $GOPATH/bin $path)

# fix raw bytes in arch git diff
export LESSCHARSET=UTF-8

export OLLAMA_NO_CLOUD=1

# zsh native key bindings
# Ctrl + 🡄
bindkey "^[[1;5D" backward-word
# Ctrl + 🡆
bindkey "^[[1;5C" forward-word

# Terraform
alias tf='terraform'

# Homebrew for MacOS
# old Intel Path
# eval "$(/usr/local/bin/brew shellenv)"
# Apple Silicon Path
eval "$(/opt/homebrew/bin/brew shellenv)"

# Mac GNU grep
# PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"

# Rust
# . "$HOME/.cargo/env"

# MacOS boilerplate
. "$HOME/.local/bin/env"

# Numerator profile
. "$HOME/.numerator_profile.sh"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
