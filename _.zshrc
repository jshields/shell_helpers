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

# fix raw bytes in arch git diff
export LESSCHARSET=UTF-8

# zsh native key bindings
# Ctrl + 🡄
bindkey "^[[1;5D" backward-word
# Ctrl + 🡆
bindkey "^[[1;5C" forward-word


# Homebrew for MacOS
# eval "$(/usr/local/bin/brew shellenv)"

# Rust
. "$HOME/.cargo/env"

# MacOS boilerplate
. "$HOME/.local/bin/env"
