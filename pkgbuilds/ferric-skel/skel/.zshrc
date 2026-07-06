# FerricOS // Quiet Ferric — zsh
autoload -Uz compinit && compinit
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history hist_ignore_dups

# prompt: cam@ferric ~/path »
PROMPT='%F{#D85A30}%n@ferric%f %F{#544C44}%~%f %F{#D85A30}»%f '

alias ls='ls --color=auto'
alias ll='ls -lah'
alias grep='grep --color=auto'
alias ff='fastfetch'

[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh