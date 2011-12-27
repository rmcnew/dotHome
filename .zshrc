#.zshrc
# amazon env vars

# profile
if [ -f /etc/profile ]; then
        source /etc/profile
fi

AUTO_TITLE_SCREENS="NO"

#### aliases ####
alias screen="/usr/bin/screen -R -D -A"
alias bc='bc -l'
alias ll='ls -lah'
alias ls='ls -F -G'
alias vim='vim -p'
alias view='vim -R -p'
alias vimdiff='vim -d'

#### exports ####
# generic #
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='vim'
export VISUAL='vim'
export ZLS_COLORS="$LS_COLORS"
export SCREENRC=~/.screenrc
export COLORFGBG="default;default"
export PATH="/home/rmcnew/bin:/bin:/usr/bin:/usr/local/bin:/usr/X11R6/bin:/sbin:/usr/sbin:/usr/local/sbin:/usr/local/texlive/2011/bin/x86_64-darwin"
export GROOVY_HOME='/usr/local/Cellar/groovy/1.8.2/libexec'
export NODE_PATH='/usr/local/lib/node_modules'

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

PAGER=less

# PROMPT explanation:
# $=' needed for colors
# %{\e[1;32m%} sets our first color. 32 is the color, changed as needed
# always end with color 00 so the CL is normal
# %n: username, %m: hostname, %1~: display the pwd (if $HOME then ~) one level
# %(!.#.$): if (su_priv) then # else $
#PROMPT=$'%(!.%{\e[1;31m%}.%{\e[1;34m%})[%m %C]%{\e[0;00m%} '
PROMPT=$'%(!.%{\e[1;31m%}.%{\e[0;36m%})[%m %C]%{\e[0;00m%} '

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

