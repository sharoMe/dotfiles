# aliases of conda command
alias cona='conda activate'
alias cond='conda deactivate' 

# global alias
alias -g @c='| pbcopy'
alias -g @g='| grep'
alias -g @l='| less'
alias -g @m='| more'
alias -g @x='| xargs'

# zplug
source ~/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# syntax highlighting
zplug "zsh-users/zsh-syntax-highlighting"
# commnad history search which you can type in any part of any command from history and then press the UP and DOWN arrows, to cycle through matches.
zplug "zsh-users/zsh-history-substring-search"
# command suggestions as you type based on history and completions.
zplug "zsh-users/zsh-autosuggestions"
# reinforced completion
zplug "zsh-users/zsh-completions"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

# Then, source plugins and add commands to $PATH
zplug load


# change 'ls' color
export LSCOLORS=Gxfxcxdxbxegedabagacad
alias ls="ls -G"
alias ll="ls -lG"
alias la="ls -laG"


#>>>>>>>>> prompt style >>>>>>>>>>>>
export CLICOLOR=1

autoload -Uz compinit && compinit  # Gitの補完を有効化

function left-prompt {
  name_t='179m%}'      # user name text clolr
  name_b='000m%}'    # user name background color
  path_t='255m%}'     # path text clolr
  path_b='031m%}'   # path background color
  arrow='087m%}'   # arrow color
  text_color='%{\e[38;5;'    # set text color
  back_color='%{\e[30;48;5;' # set background color
  reset='%{\e[0m%}'   # reset
  sharp='\uE0B0'      # triangle
  
  user="${back_color}${name_b}${text_color}${name_t}"
  dir="${back_color}${path_b}${text_color}${path_t}"
#  echo "${user}%n%#@%m${back_color}${path_b}${text_color}${name_b}${sharp} ${dir}%~${reset}${text_color}${path_b}${sharp}${reset}\n${text_color}${arrow}→ ${reset}"
  echo "${user}%n%#@%m${back_color}${path_b}${text_color}${name_b}${sharp} ${dir}%~${reset}${text_color}${path_b}${sharp}${reset} "
}

PROMPT=`left-prompt` 

# start a new line by each command
function precmd() {
    # Print a newline before the prompt, unless it's the
    # first prompt in the process.
    if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
        NEW_LINE_BEFORE_PROMPT=1
    elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
        echo ""
    fi
}
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# display git branch
function rprompt-git-current-branch {
  local branch_name st branch_status
  
  branch='\ue0a0'
  color='%{\e[38;5;'
  green='114m%}'
  red='001m%}'
  yellow='227m%}'
  blue='033m%}'
  reset='%{\e[0m%}'
  
  if test -z $(git rev-parse --git-dir 2> /dev/null); then
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    # Clear condition (Everything is committed.)
    branch_status="${color}${green}${branch}"
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    # Some file are not tracked.
    branch_status="${color}${red}${branch}?"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    # Changes not staged for commit
    branch_status="${color}${red}${branch}+"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    # Changes to be commited
    branch_status="${color}${yellow}${branch}!"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    # Confilict has occurred
    echo "${color}${red}${branch}!(no branch)${reset}"
    return
  else
    branch_status="${color}${blue}${branch}"
  fi
  # display git branch with status color
  echo "${branch_status}$branch_name${reset}"
}
 
# Evaluate and replace the prompt string everytime the prompt is displayed.
setopt prompt_subst
 
# Show git branch on the right side of the prompt
RPROMPT='`rprompt-git-current-branch`'


# Slogan
echo "Learn or Die."

