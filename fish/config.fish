# aliases
alias ll='ls -lah -F --color=always'
alias ls='ls -F --color=always'
alias vim='vim -p'
alias view='vim -R -p'
alias make="make -j$(nproc)"
alias newscreen='screen -S mcnew-desktop'
alias curscreen='screen -x mcnew-desktop'
alias newtmux="tmux new-session -s mcnew-desktop"
alias curtmux="tmux new-session -t mcnew-desktop -s $fish_pid"
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
alias ct='cargo test'
alias grs='git remote --verbose show'

# exports
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx TERM xterm-256color
set -gx EDITOR hx
set -gx VISUAL hx
set -gx PATH "$HOME/bin:$HOME/.cargo/bin:/snap/bin:$PATH"
set -gx DEBFULLNAME "Richard Scott McNew"
set -gx DEBEMAIL "scott.mcnew@canonical.com"
set -gx DEBSIGN_PROGRAM /bin/gpg
set -gx DEBSIGN_KEYID EE7615637174E222B64E10675085CAD223AD488F
set -gx DEB_BUILD_OPTIONS "parallel=$(math "$(nproc) / 2")"
set -gx GPG_TTY $(tty)

# Ubuntu architecture targets
set -gx UB_ARCH_TARGETS amd64 arm64 armhf ppc64el riscv64 s390x
# Ubuntu LTS releases with Rust needs
set -gx UB_LTS_RELEASES resolute noble jammy
# Current Ubuntu non-LTS releases
set -gx UB_NON_LTS_RELEASES plucky questing
set -gx UB_RELEASES $UB_LTS_RELEASES $UB_NON_LTS_RELEASES

# confirm function
function confirm
    read -l response -P "$argv[1] (y/N) "
    switch $response
        case y Y
            return 0
        case '*'
            return 1
    end
end

# schroot / sbuild functions
function verbose-sbuild
    DEB_BUILD_OPTIONS=verbose sbuild --verbose --debug $argv
end

function sbuild-purge
    if test -d debian
        quilt pop -a 2>/dev/null || echo "No patches applied"
        schroot -e --all-sessions
        rm -Rf /var/lib/sbuild/build/*
        rm -vf ../*.{debian.tar.xz,dsc,buildinfo,changes,ppa.upload}
        rm -vf debian/files
        rm -Rf .pc
    else
        echo "This command should only be executed in a package's source directory with the build artifacts (e.g. *.ppa.upload, *.changes, etc.) in the parent directory"
    end
end

function setup-schroots
    for arch in $UB_ARCH_TARGETS
        for rel in $UB_RELEASES
            mk-sbuild --arch $arch $rel
        end
    end
end

function remove-schroots
    if confirm "Really delete the schroots?"
        echo "Ok. Deleting the schroots . . ."
        schroot -e --all-sessions
        sudo rm /etc/schroot/chroot.d/*
        sudo rm -Rf /var/lib/schroot/chroots/*
    else
        echo "NOT deleting the schroots"
    end
end

# useful web functions adapted from https://github.com/dmi3/fish/blob/master/web.fish
alias external-ip='curl ifconfig.co'
alias internal-ip="ip -o route get to 1.1.1.1 | sed -n 's/.*src \([0-9.]\+\).*/\1/p'"
alias whereami='curl ifconfig.co/json'
alias weather='curl wttr.in'
alias randomfact='curl -s https://uselessfacts.jsph.pl/api/v2/facts/random | jq .text'

# other useful functions
function random-text --description "Generate random text" --argument-names length
    test -n "$length"; or set length 18
    head /dev/urandom | tr -dc "[:alnum:]~!#\$%^&*-+=?./|" | head -c $length | tee /dev/tty | xclip -sel clip; and echo -e "\ncopied to clipboard"
end

# set theme
fish_config theme choose "ayu Dark"
set -g fish_pager_color_selected_background --background=blue

# command prompt adapted from https://github.com/dmi3/fish/blob/master/prompt.fish
function fish_prompt
    if set -q SSH_CLIENT || set -q SSH_TTY
        set_color 909d63 --bold

        set __ssh true
        echo -n "[$USER@"(hostname)"]"
    end

    set_color --bold

    set __git_status (git status 2> /dev/null | head -1)

    # Full path + git trimmed to width of terminal
    set prompt_width (math (pwd | string length) + (string length "$__git_status") + 7)
    if test $prompt_width -gt $COLUMNS
        echo -n […(pwd | string sub -s (math $prompt_width - $COLUMNS + 4))"❯ "
    else
        echo -n [(pwd)"❯ "
    end

    # Git stuff
    if [ $__git_status!="" ]
        string match -q "On branch *" "$__git_status"

        and string replace "On branch " "⌥ " "$__git_status" | read -l __git_status

        and set_color A6E22E

        or set_color FD971F

        echo -n $__git_status

        # Need git 2.17.0+
        set_color F92672
        git status -sb --no-column --porcelain | grep -oe "ahead [0-9]*, behind [0-9]*" | string replace "ahead " " ⬆" | string replace ", behind " " ⬇" | xargs echo -n ""; or true
    end

    set -q __ssh && echo -n '🖧  ' || echo -n '➤ '
end
