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

prompt_git() {
	local s=''
	local branchName=''

	git rev-parse --is-inside-work-tree &>/dev/null || return

	branchName="$(git symbolic-ref --quiet --short HEAD 2>/dev/null ||
		git describe --all --exact-match HEAD 2>/dev/null ||
		git rev-parse --short HEAD 2>/dev/null ||
		echo '(unknown)')"

	repoUrl="$(git config --get remote.origin.url)"
	if grep -q 'chromium/src.git' <<<"${repoUrl}"; then
		s+='*'
	else
		if ! $(git diff --quiet --ignore-submodules --cached); then
			s+='+'
		fi
		if ! $(git diff-files --quiet --ignore-submodules --); then
			s+='!'
		fi
		if [ -n "$(git ls-files --others --exclude-standard)" ]; then
			s+='?'
		fi
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

if command -v exa >/dev/null 2>&1; then
  alias l='exa --classify --icons'
  alias la='exa -a --icons'
  alias ll='exa -ahlF --icons'
  alias lt='exa -lT --icons'
  alias tree='exa -T --icons'
else
  alias l='ls -CF'
  alias la='ls -Ah'
  alias ll='ls -ahlF'
  alias lt='ls -lt'
fi

# System
alias update='sudo apt update && sudo apt upgrade'

# Neovim
alias e='nvim'

export PATH="$HOME/bin:$PATH"
shopt -s nocaseglob
shopt -s histappend
shopt -s cdspell

_history_complete() {
    [[ ${#READLINE_LINE} -gt 1 ]] || { printf "\t"; return; }
    local match=$(history | tail -n 100 | sed 's/^ *[0-9]* *//' | grep "^$READLINE_LINE" | grep -v "^$READLINE_LINE$" | tail -n 1)
    [[ -n "$match" ]] && READLINE_LINE="$match" && READLINE_POINT=${#match} || printf "\t"
}
bind -x '"\t": _history_complete'
