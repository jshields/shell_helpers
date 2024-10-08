# Git branch info in prompt
# Load version control information
# https://zsh.sourceforge.io/Doc/Release/Functions.html
autoload -Uz vcs_info
precmd() { vcs_info }
# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '(%b)'

# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
setopt PROMPT_SUBST
# PROMPT='%F{green}%*%f %F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '

PROMPT='%F{yellow}%~${vcs_info_msg_0_}:%f '

# Homebrew
eval "$(/usr/local/bin/brew shellenv)"
