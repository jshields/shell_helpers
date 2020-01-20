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


function dinosaur_day() {
    date +%A | awk '{print toupper($0)}' | cowthink -f stegosaurus | lolcat
}

# back up n directories
function cd_up() {
    cd $(printf "%0.s../" $(seq 1 $1 ))
}
alias 'cd..n'='cd_up'
alias 'git-fancy-history'='git log --graph --decorate --pretty=oneline --abbrev-commit --all'
alias 'git-show-files'='git show --pretty="" --name-status'

# ~/working/dir(git_branch_name)$ as prompt:
source /etc/bash_completion.d/git-prompt
PS1='\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 "(%s)"): '
# include working dir as terminal title:
PS1="\[\e]2;\w\a\]$PS1"

# for Google Cloud if installed
#source /home/josh/google-cloud-sdk/completion.bash.inc
#source /home/josh/google-cloud-sdk/path.bash.inc


# getting / setting .joshrc config
#function create_joshrc_prompt(){
#    echo "No .joshrc found. Create ~/.joshrc? y/n"
#    read yorn
#    if test "$yorn" = "y"; then
#        touch ~/.joshrc
#    else
#       echo "Not created."
#    fi
#}

function set_conf(){
    KEY=$1
    VALUE=$2
    if [ -a ~/.joshrc ]; then
        if grep --quiet $KEY ~/.joshrc; then
            sed -i -r 's|'$KEY'=.*|'$KEY'='$VALUE'|g' ~/.joshrc
            #&& echo $KEY" changed to "$VALUE
        else
            echo $KEY=$VALUE>>~/.joshrc
            # && echo $KEY" set to "$VALUE
        fi
    else
        echo $KEY=$VALUE>>~/.joshrc && \
        echo "Created ~/.joshrc"
    fi
}

function get_conf(){
    KEY=$1
    if [ -a ~/.joshrc ]; then
        . ~/.joshrc
        RESULT=$(grep $KEY ~/.joshrc)
        # strip the key from the result to get the value
        VALUE=$(echo $RESULT | sed -r 's|'$KEY'=|''|g')
        echo $VALUE
    fi
}

export ENCOURAGE=$(get_conf ENCOURAGE)
set_conf ENCOURAGE $ENCOURAGE

# print an encouraging message
function encourage(){
    NUM=$[ 1 + $[ RANDOM % 10 ]]
    case $NUM in
    1) PHRASE="You're doing great!";;
    2) PHRASE="You're doing fantastic!";;
    3) PHRASE="You're doing exceptionally well!";;
    4) PHRASE="Wow, good job!";;
    5) PHRASE="You're out of this world!";;
    6) PHRASE="You're the best!";;
    7) PHRASE="I appreciate your enthusiasm!";;
    8) PHRASE="Yeah, it's all you!";;
    9) PHRASE="Wow, look at you go!";;
    10) PHRASE="Whoa, you're on fire!";;
    *) PHRASE="Wowee!!!";;
    esac
    echo $PHRASE
}

if [ "$ENCOURAGE" == "ON" ]; then
    encourage
fi

function draw(){
    cat ~/ascii/$1.txt
}

# function that takes LeetCode title and converts to file name
# leetcodefile "709. To Lower Case" .py -> 709_to_lower_case.py
function leetcodefile() {
    touch $(echo $1 | sed -e 's/ /_/g' | sed -e 's/\.//g' | sed -e "s/'//g" | awk '{print tolower($0)}')$2
}
