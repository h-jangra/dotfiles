eval "$(zoxide init bash)"

alias config='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'
config config status.showUntrackedFiles no

cgit() {
  if [ $# -eq 0 ]; then
    echo "Usage: cgit <file>"
    return
  fi

  local file="$1"

  # Check if file is provided
  if [[ -z "$file" ]]; then
    echo "Error: filename is required."
    return 1
  fi

  # Default message
  local message="Updated $file"

  # Get current branch
  local branch=$(config rev-parse --abbrev-ref HEAD)

  # Colors
  local CYAN="\e[36m"
  local YELLOW="\e[33m"
  local GREEN="\e[32m"
  local BOLD="\e[1m"
  local RESET="\e[0m"

  # Prepare output
  local col1="📂File: $file"
  local col2="📝Message: $message"
  local col3="🌿Branch: $branch"

  local w1=${#col1}
  local w2=${#col2}
  local w3=${#col3}

  # Draw header
  printf "${CYAN}┌─"; printf '─%.0s' $(seq 1 $w1); printf '┬'
  printf '─%.0s' $(seq 1 $w2); printf '─┬'
  printf '─%.0s' $(seq 1 $w3); printf "─┐${RESET}\n"

  # Print values
  printf "${CYAN}│${RESET}${YELLOW}${BOLD}%-*s${RESET}${CYAN}│${RESET}%-*s${RESET}${CYAN}│${RESET}${GREEN}%-*s${RESET}${CYAN}│${RESET}\n" \
  $w1 "$col1" $w2 "$col2" $w3 "$col3"

  # Draw footer
  printf "${CYAN}└─"; printf '─%.0s' $(seq 1 $w1); printf '┴'
  printf '─%.0s' $(seq 1 $w2); printf '─┴'
  printf '─%.0s' $(seq 1 $w3); printf "─┘${RESET}\n"

  # Commit and push
  config add "$file" &&
  config commit -m "$message" &&
  config push origin "$branch"
}

FNM_PATH="/home/hj/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
	export TERM='gnome-256color'
elif infocmp xterm-256color >/dev/null 2>&1; then
	export TERM='xterm-256color'
fi

prompt_git() {
	local s=''
	local branchName=''

	# Check if the current directory is in a Git repository.
	git rev-parse --is-inside-work-tree &>/dev/null || return

	# Check for what branch we’re on.
	# Get the short symbolic ref. If HEAD isn’t a symbolic ref, get a
	# tracking remote branch or tag. Otherwise, get the
	# short SHA for the latest commit, or give up.
	branchName="$(git symbolic-ref --quiet --short HEAD 2>/dev/null ||
		git describe --all --exact-match HEAD 2>/dev/null ||
		git rev-parse --short HEAD 2>/dev/null ||
		echo '(unknown)')"

	# Early exit for Chromium & Blink repo, as the dirty check takes too long.
	# Thanks, @paulirish!
	# https://github.com/paulirish/dotfiles/blob/dd33151f/.bash_prompt#L110-L123
	repoUrl="$(git config --get remote.origin.url)"
	if grep -q 'chromium/src.git' <<<"${repoUrl}"; then
		s+='*'
	else
		# Check for uncommitted changes in the index.
		if ! $(git diff --quiet --ignore-submodules --cached); then
			s+='+'
		fi
		# Check for unstaged changes.
		if ! $(git diff-files --quiet --ignore-submodules --); then
			s+='!'
		fi
		# Check for untracked files.
		if [ -n "$(git ls-files --others --exclude-standard)" ]; then
			s+='?'
		fi
		# Check for stashed files.
		if $(git rev-parse --verify refs/stash &>/dev/null); then
			s+='$'
		fi
	fi

	[ -n "${s}" ] && s=" [${s}]"

	echo -e "[${1}${branchName}${2}${s}]"
}

if tput setaf 1 &>/dev/null; then
	tput sgr0 # reset colors
	bold=$(tput bold)
	reset=$(tput sgr0)
	# Solarized colors, taken from http://git.io/solarized-colors.
	black=$(tput setaf 0)
	blue=$(tput setaf 33)
	cyan=$(tput setaf 37)
	green=$(tput setaf 64)
	orange=$(tput setaf 166)
	purple=$(tput setaf 125)
	red=$(tput setaf 124)
	violet=$(tput setaf 61)
	white=$(tput setaf 15)
	yellow=$(tput setaf 136)
else
	bold=''
	reset="\e[0m"
	black="\e[1;30m"
	blue="\e[1;34m"
	cyan="\e[1;36m"
	green="\e[1;32m"
	orange="\e[1;33m"
	purple="\e[1;35m"
	red="\e[1;31m"
	violet="\e[1;35m"
	white="\e[1;37m"
	yellow="\e[1;33m"
fi

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
	userStyle="${red}"
else
	userStyle="${orange}"
fi

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
	hostStyle="${bold}${red}"
else
	hostStyle="${yellow}"
fi

# Set the terminal title and prompt.
PS1="\[\033]0;\w\007\]"                                                 # working directory base name
PS1+="\[${bold}\]\n"                                                    # newline
PS1+="\[${blue}\]╭─(\W)"                                                # working directory full path
PS1+="\$(prompt_git \"\[${white}\] on \[${violet}\]\" \"\[${blue}\]\")" # Git repository details
PS1+="\n"
PS1+="╰─§ \[${reset}\]" #
export PS1

PS2="\[${yellow}\]› \[${reset}\]"
export PS2

# Aliases
alias cls='clear'
alias c='clear'
alias q='exit'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias home='cd ~'
alias docs='cd ~/Documents'
alias dl='cd ~/Downloads'

if command -v exa >/dev/null 2>&1; then
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
  alias ltr='ls -ltr'
fi

# Git
alias g='git'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gb='git branch'
alias gco='git checkout'

# System
alias update='sudo apt update && sudo apt upgrade'
alias htop='htop'

# Docker
alias d='docker'
alias dps='docker ps'
alias dcu='docker compose up'
alias dcd='docker compose down'

# NPM/Yarn
alias ni='npm install'
alias nr='npm run'
alias nid='npm install --save-dev'
alias nu='npm update'
alias ys='yarn start'
alias yb='yarn build'

# Neovim
alias v='nvim'
alias vim='nvim'

# Misc
alias pingg='ping google.com'
alias path='echo $PATH'
alias ip='curl ifconfig.me'


# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2>/dev/null
done

# Add tab completion for many Bash commands
if which brew &>/dev/null && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
	# Ensure existing Homebrew v1 completions continue to work
	export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d"
	source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion
fi

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &>/dev/null; then
	complete -o default -o nospace -F _git g
fi

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall
