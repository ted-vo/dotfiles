
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/ Custom plugins may be added to $ZSH_CUSTOM/plugins/ Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  zsh-syntax-highlighting
  zsh-autosuggestions
  git
	kubectl # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl
	encode64 # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/encode64
	golang # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/golang
	tmux # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/tmux
	terraform
)

source $ZSH/oh-my-zsh.sh

# -- tmux -------------------------------------------------------------------------------------------------------
ZSH_TMUX_CONFIG="~/.tmux.conf.local"

# -- Golang -----------------------------------------------------------------------------------------------------
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$GOBIN:$PATH

# Python3
export PATH=$(pyenv root)/shims:$PATH

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias zshconfig="vim ~/.zshrc"
alias p10ku="git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull"
alias vim=nvim

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/V9N/.google-cloud-sdk/path.zsh.inc' ]; then . '/Users/V9N/.google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/V9N/.google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/V9N/.google-cloud-sdk/completion.zsh.inc'; fi

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export PATH="$PATH:${HOME}/.krew/bin"

export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion 

export PATH="$PATH:/Users/V9N/istio-1.16.1/bin" 

# ILT ALIAS
export NPM_TOKEN=glpat-zCXEM2iyxyqHPjt-16s_

# pnpm
alias pn=pnpm
export PNPM_HOME="/Users/V9N/.pnpm/store"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export GOOGLE_APPLICATION_CREDENTIALS=/Users/V9N/.config/gcloud/application_default_credentials.json

alias kcontext-gameportal="gcloud config configurations activate athena-ilt && kcuc gke_athena-ilt_asia-southeast1-a_dev-gke-game-portal-cluster-ase1"
alias kcontext-payment="gcloud config configurations activate athena-ilt && kcuc gke_athena-ilt_asia-southeast1-a_dev-gke-payment-cluster-ase1"
alias kcontext-default="gcloud config configurations activate default && kcuc gke_athena-ilt_asia-east1-a_dev-gke-cluster-ase1-xds"

alias vvelectric="cd /Users/V9N/Workspaces/com.vv-electronics"
alias athena="cd /Users/V9N/Workspaces/io.inspirelab/athena"

autoload -U compinit; compinit

# toolbox/bin
export PATH="/Users/V9N/Workspaces/dev.tedvo/toolbox/bin:$PATH"

# Bitwadern
export BW_SESSION="Ks2KJfS/ZFfCjdBYGt9Rzpur+8YGJq5kR4PYXOyDoHRCTDQcrF/tSfa62ueNcZC3ljD+9bMvZp8GnUh+AH6qMw=="

# asdf
. /usr/local/opt/asdf/libexec/asdf.sh

# pki shell
alias pki=/Users/V9N/Workspaces/io.inspirelab/athena/devops/toolbox/pkis/scripts/pki
source /Users/V9N/Workspaces/io.inspirelab/athena/devops/toolbox/pkis/scripts/pki-completion.bash

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/mc mc

# toolbox/bin
export PATH="/Users/V9N/Workspaces/dev.tedvo/toolbox/bin:$PATH"
