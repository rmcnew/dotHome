
# profile
if [ -f /etc/profile ]; then
        source /etc/profile
fi

AUTO_TITLE_SCREENS="NO"

#### aliases ####
alias bc='bc -l'
alias ll='ls -lah'
alias ls='ls -F -G'
alias vim='vim -p'
alias view='vim -R -p'
alias make='make -j4'
alias newscreen='/usr/bin/screen -S mcnew-desktop'
alias screen='/usr/bin/screen -x mcnew-desktop'
alias ytdl='~/bin/youtube-dl'
alias ytdlx='~bin/youtube-dl -x --audio-format mp3'
alias pws='python3 -m http.server 8000'

#### exports ####
# generic #
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='vim'
export VISUAL='vim'
export ZLS_COLORS="$LS_COLORS"
export SCREENRC=~/.screenrc
export COLORFGBG="default;default"
export PATH="/home/rmcnew/bin:/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:/opt/node/bin"

#### zsh key bindings ####
bindkey '^[[3~' delete-char
bindkey '^[[7~' beginning-of-line
bindkey '^[[8~' end-of-line
bindkey -e
stty sane

# don't kill rdesktop if the shell exits
setopt NOHUP
setopt no_beep

# history
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000


# PROMPT explanation:
# $=' needed for colors
# %{\e[1;32m%} sets our first color. 32 is the color, changed as needed
# always end with color 00 so the CL is normal
# %n: username, %m: hostname, %1~: display the pwd (if $HOME then ~) one level
# %(!.#.$): if (su_priv) then # else $
#PROMPT=$'%(!.%{\e[1;31m%}.%{\e[1;34m%})[%m %C]%{\e[0;00m%} '
PROMPT=$'%(!.%{\e[1;31m%}.%{\e[0;36m%})[%m %/]%{\e[0;00m%} '

# RPROMPT (shows up at the end of a line)
# if (exit code wasn't bad) then else display the exit code
RPROMPT=$'%{\e[0;32m%}%(?..%?)%{\e[0;00m%}'

# make tab-completion even better. (for example: emerge something<tab> works)
autoload -U compinit
compinit

# completion settings.
# I don't like having a horde of users, and want some specific machines for ssh
#zstyle ':completion:*' hosts somewhere.example.com

zstyle ':completion:*' completer _expand _complete

zstyle ':completion:*' users me root

#unset DISPLAY

export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;33m'     # begin blink
export LESS_TERMCAP_so=$'\e[01;44;37m' # begin reverse video
export LESS_TERMCAP_us=$'\e[01;37m'    # begin underline
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal
export MANPAGER='less -s -M +Gg'
