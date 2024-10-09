export EDITOR='/usr/bin/vim' # /usr/local/bin/code

export GOPATH=$HOME/workspace/go
export PYENV_ROOT="$HOME/.pyenv"

export PATH=~/bin:$PYENV_ROOT/bin:/opt/homebrew/bin:$GOPATH/bin:$PATH

eval "$(pyenv init -)"

alias xcopy='xclip -selection clipboard'
alias xpaste='xclip -selection clipboard -o'
alias reader='xpaste | espeak'
alias commandlist='compgen -A function -abck'

alias 'count-dirs-here'='ls -l . | grep -c ^d'
alias 'count-files-here'='ls -al | grep ^[-] | wc -l'

function find_file() {
  find . -iname '$1'
}

alias 'time-since-login'='who -b'

alias 'git-fancy-history'='git log --graph --decorate --pretty=oneline --abbrev-commit --all'
alias 'git-show-files'='git show --pretty="" --name-status'

# rebase:
# git fetch origin
# git rebase -i origin/dev

alias 'gh-myprs'='gh pr list --author "@me"'

# back up n directories
function cd_up() {
    cd $(printf "%0.s../" $(seq 1 $1 ))
}
alias 'cd..n'='cd_up'

# For fun
function dinosaur_day() {
    date +%A | awk '{print toupper($0)}' | cowthink -f stegosaurus | lolcat
}
function draw(){
    cat ~/ascii/$1.txt
}

# Git completions for access to __git_ps1, needed for prompt
# Homebrew completions with bash-completion
# Intel
# [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
# Apple Silicon
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

if [ -f $(brew --prefix)/etc/bash_completion.d/git-prompt.sh ]; then
    # Mac Homebrew
    source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
else
    source /etc/bash_completion/git-prompt
fi

# "~/working/dir(git_branch_name): " as prompt:
# Escape, then 01;33m is bold yellow, 00m is reset
PS1='\[\033[01;33m\]\w\[\033[00m\]$(__git_ps1 "(%s)"): '
# include working dir as terminal title:
PS1="\[\e]2;\w\a\]$PS1"

# for Google Cloud if installed
#source /home/josh/google-cloud-sdk/completion.bash.inc
#source /home/josh/google-cloud-sdk/path.bash.inc

# Function that takes LeetCode title and file extension as args, creates file with cleaned filename.
# Discard parentheses, period, single quote.
# leetcodefile "709. To Lower Case" .py -> 709_to_lower_case.py
function leetcodefile() {
    touch $(echo $1 | sed -e 's/ /_/g' | sed -e "s/[\(\)\.']//g" | awk '{print tolower($0)}')$2
}

function open_files_subl () {
  subl $(ag --files-with-matches "$1")
}

function open_files_code () {
  code $(ag --files-with-matches "$1")
}

function open_last_files_subl () {
  subl $(git show --pretty="" --name-only)
}

function open_last_files_code () {
  code $(git show --pretty="" --name-only)
}

function findf () {
  find . -iname "$1"
}

function kill-port () {
  kill $(lsof -t -i :$1)
}

# Mac
# colored directories / symlinks on OSX
export LSCOLORS="EHfxcxdxBxegecabagacad"
alias ls='ls -lGH'
# using bash not zsh
export BASH_SILENCE_DEPRECATION_WARNING=1


# GNU Grep for Mac
# ~: which grep
# /usr/bin/grep
# ~: brew install grep
# ==> grep
# All commands have been installed with the prefix "g".
# If you need to use these commands with their normal names, you
# can add a "gnubin" directory to your PATH from your bashrc like:
# PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"


# if more overrides are needed
#source ~/.joshrc

# Windows
# set VS Code as git editor:
# git config --global core.editor "code --wait"
# Convenience for WSL:
# TODO export this when platform is detected as windows
# https://gist.github.com/prabirshrestha/3080525#gistcomment-2962265
#export WINHOME=/mnt/c/Users/Josh


# work profile (do not store in version control)
source ~/.numerator_profile.sh

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
