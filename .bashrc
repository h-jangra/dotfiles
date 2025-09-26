eval "$(zoxide init bash)"

alias config='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'
config config status.showUntrackedFiles no

cgit() {
  if [ $# -eq 0 ]; then
    echo "Usage: cgit -f <file> [-m <message>] [-b $br]"
    return
  fi

  local message=""
  local branch=""
  local file=""

  OPTIND=1
  while getopts ":f:m:b:" opt; do
    case $opt in
      f) file="$OPTARG" ;;
      m) message="$OPTARG" ;;
      b) branch="$OPTARG" ;;
      *)
        echo "Usage: cgit -f <file> [-m <message>] [-b <branch>]"
        return 1
        ;;
    esac
  done

  if [[ -z "$file" ]]; then
    echo "Error: -f <file> is required."
    return 1
  fi

  shift $((OPTIND - 1))

  if [ -z "$message" ]; then
    message="Updated $file"
  fi

  if [ -z "$branch" ]; then
    branch=$(config rev-parse --abbrev-ref HEAD)
  fi

  GREEN="\e[32m"
  YELLOW="\e[33m"
  CYAN="\e[36m"
  BOLD="\e[1m"
  RESET="\e[0m"

  col1="📂File: $file"
  col2="📝Message: $message"
  col3="🌿Branch: $branch"

  w1=${#col1}
  w2=${#col2}
  w3=${#col3}

  printf "${CYAN}┌─"; printf '─%.0s' $(seq 1 $w1); printf '┬'
  printf '─%.0s' $(seq 1 $w2); printf '─┬'
  printf '─%.0s' $(seq 1 $w3); printf "─┐${RESET}\n"

  printf "${CYAN}│${RESET}${YELLOW}${BOLD}%-*s${RESET}${CYAN}│${RESET}%-*s${RESET}${CYAN}│${RESET}${GREEN}%-*s${RESET}${CYAN}│${RESET}\n" \
  $w1 "$col1" $w2 "$col2" $w3 "$col3"

  printf "${CYAN}└─"; printf '─%.0s' $(seq 1 $w1); printf '┴'
  printf '─%.0s' $(seq 1 $w2); printf '─┴'
  printf '─%.0s' $(seq 1 $w3); printf "─┘${RESET}\n"


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
PS1+="╰─› \[${reset}\]" #
export PS1

PS2="\[${yellow}\]› \[${reset}\]"
export PS2

# Aliases
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

# System
alias update='sudo apt update && sudo apt upgrade'
# Neovim
alias v='nvim'

# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH"
