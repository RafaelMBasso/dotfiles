# Zinit
source ~/.local/share/zinit/zinit.git/zinit.zsh

# Histórico
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

# Autocompletar (precisa rodar ANTES do fzf-tab)
autoload -Uz compinit && compinit

# fzf-tab: precisa carregar depois do compinit, mas ANTES de plugins
# que "embrulham" widgets (autosuggestions, syntax-highlighting)
zinit light Aloxaf/fzf-tab

# Plugins que dependem de keybindings do vi-mode devem carregar
# DEPOIS dele — o hook zvm_after_init garante essa ordem certa
function zvm_after_init() {
  zinit light zsh-users/zsh-autosuggestions
  zinit light joshskidmore/zsh-fzf-history-search
  zinit light zsh-users/zsh-syntax-highlighting
}

# zsh-vi-mode — deve ser o último "zinit light" chamado diretamente
zinit light jeffreytse/zsh-vi-mode

# Aliases uteis
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first'
alias lt='eza --tree --icons --level=2'
alias grep='grep --color=auto'
alias update='sudo pacman -Syu'

# Dotfiles (bare repo)
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

export EDITOR=nano
eval "$(starship init zsh)"
