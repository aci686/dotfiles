# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/i686/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/i686/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/i686/.fzf/shell/key-bindings.zsh"
