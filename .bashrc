# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

set_prompt() {
  # Escape sequences:
  # http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html
  # Color codes:
  # http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
  local green=""
  local blue=""
  local no_color=""
  local username="\u"
  local host="\h"
  local fqdn="\H"
  local working_dir="\w"
  local debian_chroot='${debian_chroot:+($debian_chroot)}'
  if [ "$color_prompt" = yes ]; then
    green="\[\033[01;32m\]"
    blue="\[\033[01;94m\]"
    no_color="\[\033[0m\]"
  fi
  PS1="${green}${username}@${fqdn}${no_color}:${blue}${working_dir}${no_color}\n\$ "

}
set_prompt
unset color_prompt force_color_prompt set_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Gets the size of specified folder. Defaults to "."
function foldersize() {
  local folder="${1:-.}"
  local args=(
    "-d1" # Show only files in this folder
    "-h" # Human-readable file sizes
    "--threshold=5242880" # 5MB
  )
  sudo du "${args[@]}" "$folder" | sort -rh
}

function lsport() {
  sudo netstat -nlp | grep ":$1"
}

function lskill() {
  read -r -d '' kill_script <<-'EOF'
# test_string_ignore
import sys
import subprocess

argv = sys.argv
if len(argv) == 1:
  print('Usage: lskill [process_name]')
  sys.exit(0)

print(sys.argv)
search_string = sys.argv[1]
ps_output = subprocess.check_output(
    'ps --no-headers -axo "pid,cmd,args" | sed "s/  / /g"  | grep "%s"'
        % search_string,
    shell=True,
    encoding='ascii')
process_strings = [x for x in ps_output.split('\n')
    if x and not 'test_string_ignore' in x]

for i, process_string in enumerate(process_strings):
  print('%d:  %s' % (i, process_string))

print()
process_index = int(input('Pick a process number(0): ') or 0)
pid = process_strings[process_index].split()[0]
print('Killing pid %s' %  pid)
subprocess.check_call('kill "%s"' % pid, shell=True)

EOF

  python3 -c "$kill_script" $@
}

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ap=ansible-playbook
alias bashrc="vim ~/.bashrc && source ~/.bashrc"
alias count="wc -l"
alias du-default="/usr/bin/du"
alias du="/usr/bin/du -d1 -h"
alias l='ls -CFh'
alias la='ls -Ah'
alias ll='ls -alFh'
alias vimrc="vim ~/.vimrc"

export EDITOR=vim

# Pick up any local bashrc files.
for rcfile in "$(ls -a ~/.bashrc-*)"; do
  . "$rcfile"
done
