# if not running interactively, don't do anything
# [ -z "$PS1" ] && return

par=$1

function parse_git_dirty {
[[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
}
function parse_git_branch {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\(\1$(parse_git_dirty)\)/"
}

function code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args "$@"; }

PS1="\t \u@\h:\w\[\033[31m\]\$(parse_git_branch)\[\033[00m\]> "

export AFSCERN="/afs/cern.ch/user/l/laphecet"
export AFSIN2P3="/afs/in2p3.fr/home/a/aphecetc"

alias ccin2p3='cd $AFSIN2P3'

alias cern='cd $AFSCERN'

#alias e='edit' # for TextWrangler
#alias e='$HOME/bin/subl' # for Sublime Text
alias e='atom ' # Atom text editor

alias ali='source ~/alicesw/alice-env.sh'
alias dali='source ~/cern-alice-setup/alice-env.sh'

alias alice-installer='bash <(curl -fsSL http://alien.cern.ch/alice-installer)'

alias ll='ls -al'

alias token='alien-token-init laphecet'

alias rgrep="find . -follow -type f -name '*.cxx' | xargs grep -iHn "

alias rh='cat $HOME/.root_hist'

alias ra='root -l $HOME/macros/loadlibs.C'

alias la='aliroot -l $HOME/macros/loadlibs.C'

alias irst='source $HOME/Scripts/alice-irst.sh'

alias rmds='find . -name ".DS_Store" -type f -print0 | xargs -0 rm'

alias locate='mdfind -name'

alias dox='source $HOME/Scripts/alice-doxygen.sh'

alias vaf='ssh laphecet@localhost -p 5522 -Y'

alias gssh='gsissh -p 1975'

alias gscp='gsiscp -S `which gsissh` -P 1975'

alias saf3-enter='source $HOME/Scripts/saf3.sh enter'
alias saf3='source $HOME/Scripts/saf3.sh'

alias o2='source $HOME/Scripts/o2-env.sh'

alias cvmfs='source $HOME/Scripts/cvmfs.sh'

alias ks='screen -ls | grep -o "[0-9]\{5\}" | awk "{print $1}"| xargs -I{} screen -S {} -X quit'

alias dhcp-start='sudo /bin/launchctl load -w /System/Library/LaunchDaemons/bootps.plist'

alias dhcp-stop='sudo /bin/launchctl unload -w /System/Library/LaunchDaemons/bootps.plist'

export PATH=$PATH:$HOME/Bin
export PATH=$PATH:/usr/texbin
export PATH=$PATH:$HOME/aafu
export PATH=$PATH:/Applications/CMake.app/Contents/bin/
export PATH=$PATH:/usr/local/go

export GOPATH=$HOME/gowork
export PATH=$PATH:$GOPATH/bin

export ALICE_ENV_DONT_UPDATE=1


source ~/alicesw/alice-env.sh $par

