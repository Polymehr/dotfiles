# Path to your oh-my-zsh installation.
export ZSH=/home/polymehr/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
if [[ "$TTY" != /dev/tty[0-9] ]]; then
    ZSH_THEME="powerlevel9k/powerlevel9k"

    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs vi_mode command_execution_time)
    DEFAULT_USER=$USER
else
    ZSH_THEME="candy"
fi

# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# export UPDATE_ZSH_DAYS=13
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
  COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
  HIST_STAMPS="yyyy-mm-dd"
# ZSH_CUSTOM=/path/to/new-custom-folder
plugins=(git)

# User configuration

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

source /etc/locale.conf
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

export EDITOR=nvim


alias gcd1="git clone --depth 1"
alias vim='\nvim'
alias lvim='\vim'
alias audio="$HOME/.i3/audio.sh -C"

#Load autojump
. /usr/share/autojump/autojump.zsh

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

function fat32copy {
    NUM=0
    TOTAL="$( find "$1" -type f | wc -l )"
    AC_DIR="$( dirname "$1" )"

    find "$1" -type f -print0 | while IFS= read -r -d $'\0' F; do
        ((NUM++))
        DEST="$(echo "$F" | sed -e 's/:/ -/g' | sed -e 's/"/'\''/g' | sed -e 's/[|\?*]/_/g')"
        DIR="$(dirname "$DEST")"
        DIR="$2${DIR#$AC_DIR}"
        FILE="$(basename "$DEST")"
        printf "\r\e[0K%3.2f%% (%d/%d): '%s'" "$(echo "scale=4; $NUM/$TOTAL*100" | bc)" $NUM $TOTAL "$FILE"
        if [ ! -d "$DIR" ]; then
            mkdir -p "$DIR"
        fi
        #echo Copy from "'$F'" to "'$DEST'"
        cp "$F" "$DIR/$FILE"
    done
    echo
}
 
function audiolength() {
#http://www.commandlinefu.com/commands/view/13459/get-the-total-length-of-all-videos-in-the-current-dir-in-hms
    [ -z "$1" ] && 1='.'
    find "$1" -type f -not -path '*/\.*' -iregex '.*\.\(mp3\|wma\|flac\|ogg\|wav\|opus\)' -print0 |\
        xargs -0 mplayer -vo dummy -ao dummy -identify 2>/dev/null |\
        perl -nle '/ID_LENGTH=([0-9\.]+)/ && ($t +=$1) && printf "%20d d %02d:%02d:%02d\n",$t/86400,$t/3600%24,$t/60%60,$t%60' |\
        tail -n 1
}

function mkpdf() {
    latexmk -pdf "$1"
    latexmk -c
}

function qbg() {
    "$@">/dev/null&disown
}
function rqbg() {
    "$@"&>/dev/null&disown
}
