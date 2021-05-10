# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/$(whomai)/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/$(whomai)/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/$(whomai)/.fzf/shell/key-bindings.zsh"
