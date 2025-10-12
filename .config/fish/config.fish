source /usr/share/cachyos-fish-config/cachyos-config.fish

if type -q zoxide
    zoxide init fish | source
end

function cgit
    if test (count $argv) -eq 0
        echo "Usage: cgit <file>"
        return
    end

    set -l file $argv[1]

    if test -z "$file"
        echo "Error: filename is required."
        return 1
    end

    # Default message
    set -l message "Updated $file"

    # Current branch
    set -l branch (config rev-parse --abbrev-ref HEAD)

    # Colors
    set -l CYAN (printf "\e[36m")
    set -l YELLOW (printf "\e[33m")
    set -l GREEN (printf "\e[32m")
    set -l BOLD (printf "\e[1m")
    set -l RESET (printf "\e[0m")

    # Columns
    set -l col1 "📂File: $file"
    set -l col2 "📝Message: $message"
    set -l col3 "🌿Branch: $branch"

    set -l w1 (string length -- "$col1")
    set -l w2 (string length -- "$col2")
    set -l w3 (string length -- "$col3")

    # Draw header
    printf "%s┌─" $CYAN
    printf '─%.0s' (seq 1 $w1)
    printf '┬'
    printf '─%.0s' (seq 1 $w2)
    printf '─┬'
    printf '─%.0s' (seq 1 $w3)
    printf "─┐%s\n" $RESET

    # Print values row
    printf "%s│%s%s%-*s%s%s│%s%-*s%s%s│%s%-*s%s%s│%s\n" \
        $CYAN $RESET $YELLOW $w1 "$col1" $RESET $CYAN \
        $RESET $w2 "$col2" $RESET $CYAN \
        $RESET $GREEN $w3 "$col3" $RESET $CYAN \
        $RESET

    # Draw footer
    printf "%s└─" $CYAN
    printf '─%.0s' (seq 1 $w1)
    printf '┴'
    printf '─%.0s' (seq 1 $w2)
    printf '─┴'
    printf '─%.0s' (seq 1 $w3)
    printf "─┘%s\n" $RESET

    # Commit and push
    config add "$file"
    and config commit -m "$message"
    and config push origin "$branch"
end

# --- Git dotfiles alias ---
alias config='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'
config config status.showUntrackedFiles no

# --- Aliases ---
alias cls='clear'
alias c='clear'
alias q='exit'

# ls / exa
if type -q exa
    alias l='exa --classify --icons'
    alias la='exa -a --icons'
    alias ll='exa -alF --icons'
    alias lt='exa -lT --icons'
    alias tree='exa -T --icons'
else
    alias l='ls -CF'
    alias la='ls -A'
    alias ll='ls -alF'
    alias lt='ls -lt'
end

# System
# alias update='sudo apt update && sudo apt upgrade'
alias update='sudo pacman -Syu'

# Neovim
alias e='nvim'
alias hx='helix'

# --- PATH ---
fish_add_path ~/bin
