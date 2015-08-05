# bash_helpers additions
# add home bin to the path var, so commands from there can be run
export PATH=~/bin/:$PATH
#/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

alias w='cd ~/workspace'
alias copy='xclip -selection clipboard'
alias paste='xclip -selection clipboard -o'
alias reader='paste | espeak'
alias commandlist='compgen -A function -abck'
alias push="pushd"
alias pop="popd"

# TODO implement --quiet
function feedback(){
	if [ ! $FEEDBACKMODE ]; then
		echo "No feedback mode set. Defaulting to TEXT"
		# set_config FEEDBACKMODE TEXT
		FEEDBACKMODE="TEXT"
	fi
	case $FEEDBACKMODE in
		"TEXT" ) echo $1;;
		"AUDIBLE" ) espeak $1;;
		"BOTH" )
			echo $1
			espeak $1
			;;
		"NONE" ) ;;
		* ) ;;
	esac
}

# light API for getting / setting .joshrc config
function set_conf(){
	KEY=$1
	VALUE=$2
	if [ -a ~/.joshrc ]; then
		# if the key is already in the config, overwrite it
		if grep --quiet $KEY ~/.joshrc; then
			sed -i -r 's|'$KEY'=.*|'$KEY'='$VALUE'|g' ~/.joshrc
			#echo $KEY" changed to "$VALUE
		else
			echo $KEY" set to "$VALUE
			echo $KEY=$VALUE>>~/.joshrc
		fi
	else
		echo "Creating ~/.joshrc from setter"
		echo "\n"$KEY=$VALUE>>~/.joshrc
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
	else
		# not working
		echo "No .joshrc found. Create ~/.joshrc?"
		read yorn;
		if test "$yorn" = "y"; then
			echo "Creating ~/.joshrc from getter"
			# populating default value
			set_conf ENCOURAGE ON
		else
		   echo "Not created.";
		fi
	fi
}

ENCOURAGE=$(get_conf ENCOURAGE)
set_conf ENCOURAGE $ENCOURAGE

# print an encouraging message TODO: load these from a file
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
	10) PHRASE="Woah, you're on fire but not literally!";;
	*) PHRASE="Woah woah!!!";;
	esac
	echo $PHRASE
}

if [ "$ENCOURAGE" == "ON" ]; then
	encourage
fi

alias g='get_conf'
alias s='set_conf'
alias renew='sudo service network-manager restart'

function draw(){
	cat ~/ascii/animals/$1.txt
}


# if you're in a git repo, warn when standard rm and mv are used over git rm and git mv
# TODO
# echo "Did you mean git rm?"
# read yorn;
# if test "$yorn" = "y"; then
	# git rm $1