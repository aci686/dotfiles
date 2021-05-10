# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/[username]/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/[username]/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/[username]/.fzf/shell/key-bindings.zsh"
