
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
