AUTO_TITLE_SCREENS="NO"

#### aliases ####
alias bc='bc -l'
alias ll='ls -lah -F --color=always'
alias ls='ls -F --color=always'
alias vim='vim -p'
alias view='vim -R -p'
CPU_COUNT=`nproc`
alias make="make -j$CPU_COUNT"
alias newscreen='/usr/bin/screen -S mcnew-desktop'
alias curscreen='/usr/bin/screen -x mcnew-desktop'
alias newtmux="tmux new-session -s mcnew-desktop"
alias curtmux="tmux new-session -t mcnew-desktop -s $$"
alias wgrab='wget --random-wait -E -r -k -p -np '
alias update='sudo apt update && sudo apt -y upgrade && sudo apt -y autoremove'
alias pdf2word='libreoffice --invisible --infilter="writer_pdf_import" --convert-to docx:"MS Word 2007 XML"'
alias ytdlx='yt-dlp -x --audio-format mp3'
alias cmakeg='cmake -B build'
alias cmakegr='cmake -B build -DCMAKE_BUILD_TYPE=Release'
alias cmakeb='cmake --build build'
alias cmakebr='cmake --build build --config Release'
alias cmakegb='cmake -B build && cmake --build build'
alias cmakegbr='cmake -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
alias cmakegbt='cmake -B build && cmake --build build && ctest'
alias cmakegbrt='cmake -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && ctest -C Release'
alias clangwasm='clang --target=wasm32 -nostdlib -Wl,--no-entry -Wl,--export-all'
alias cbr='cargo build --release'
alias cbrw='cargo build --release --target wasm32-unknown-unknown'

#### exports ####
# generic #
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='vim'
export VISUAL='vim'
export ZLS_COLORS="$LS_COLORS"
export SCREENRC=~/.screenrc
export COLORFGBG="default;default"
export CUDA_BASE="/usr/local/cuda"
SYSTEM_BINS="/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin"
CUDA_BIN="$CUDA_BASE/bin"
CARGO_BIN="$HOME/.cargo/bin"
GO_BIN="$HOME/opt/go/bin"
export PATH="$HOME/bin:$CARGO_BIN:$GO_BIN:$SYSTEM_BINS:$CUDA_BIN:$PATH"
export LD_LIBRARY_PATH="$CUDA_BASE/lib64:$LD_LIBRARY_PATH"
export C_INCLUDE_PATH="$CUDA_BASE/include:$C_INCLUDE_PATH"
export CPLUS_INCLUDE_PATH="$CUDA_BASE/include:$CPLUS_INCLUDE_PATH"
unset SSH_ASKPASS


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
# %n: username, %m: hostname, %~: display the pwd (if $HOME then ~)
# %(!.#.$): if (su_priv) then # else $
PROMPT=$'%(!.%{\e[1;31m%}.%{\e[0;36m%})[%m %/]%{\e[0;00m%} '

# RPROMPT (shows up at the end of a line)
# if (exit code wasn't bad) then else display the exit code
RPROMPT=$'%{\e[0;32m%}%(?..%?)%{\e[0;00m%}'

# make tab-completion even better. (for example: emerge something<tab> works)
autoload -U compinit
compinit

# increase file limit
ulimit -n unlimited

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
