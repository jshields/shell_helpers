export EDITOR='/usr/bin/vim'
export GOPATH=$HOME/workspace/go
export PATH=~/bin/:$GOPATH/bin:$PATH

alias science='export PATH=/home/josh/anaconda3/bin:$PATH && source activate science'
alias unscience='source deactivate science && unset PATH && export PATH=~/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

alias xcopy='xclip -selection clipboard'
alias xpaste='xclip -selection clipboard -o'
alias reader='xpaste | espeak'
alias commandlist='compgen -A function -abck'

alias 'count-dirs-here'='ls -l . | grep -c ^d'
alias 'count-files-here'='ls -al | grep ^[-] | wc -l'

alias 'time-since-login'='who -b'

alias 'git-fancy-history'='git log --graph --decorate --pretty=oneline --abbrev-commit --all'
alias 'git-show-files'='git show --pretty="" --name-status'

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
if [ -f $(brew --prefix)/etc/bash_completion.d/git-prompt.sh ]; then
    # Mac Homebrew
    source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
else
    source /etc/bash_completion/git-prompt
fi
# ~/working/dir(git_branch_name)$ as prompt:
PS1='\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 "(%s)"): '
# include working dir as terminal title:
PS1="\[\e]2;\w\a\]$PS1"

# for Google Cloud if installed
#source /home/josh/google-cloud-sdk/completion.bash.inc
#source /home/josh/google-cloud-sdk/path.bash.inc

# function that takes LeetCode title and converts to file name
# leetcodefile "709. To Lower Case" .py -> 709_to_lower_case.py
function leetcodefile() {
    touch $(echo $1 | sed -e 's/ /_/g' | sed -e 's/\.//g' | sed -e "s/'//g" | awk '{print tolower($0)}')$2
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

# if more overrides are needed
#source ~/.joshrc
