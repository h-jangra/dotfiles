source /usr/share/cachyos-fish-config/cachyos-config.fish
set -gx PATH (npm prefix -g)/bin $PATH

set -Ux LANG en_US.UTF-8
set -Ux LC_ALL en_US.UTF-8
set -gx PATH /usr/lib/emscripten $PATH

export EDITOR=nvim
export TERMINAL=foot

function fish_title
    set -l cwd (basename "$PWD")
    printf '%s' "$cwd"
end

export EDITOR=nvim
export VISUAL=nvim

function fish_greeting
end

zoxide init fish | source

alias tree='exa --tree'

function rm --wraps rm
    read -P "Really? [y/N] " c; string match -qi y $c; and command rm $argv
end

function mem
    smem -tkP $argv[1] | tail -1 | awk '{print $NF}'
end
