########################################################
# Powerlevel10k
########################################################
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

########################################################
# oh-my-zsh
########################################################
export ZSH="/Users/yusuf.mahtab/.oh-my-zsh"

# Autocomplete
# N.B. compinit is for file completion, zsh-autosuggestions is for cli prediction
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
COMPLETION_WAITING_DOTS="true"

# Customisation
setopt NO_BEEP
ZSH_THEME="powerlevel10k/powerlevel10k"
zstyle ':omz:update' mode reminder
HIST_STAMPS="mm/dd/yyyy"

# Standard plugins in $ZSH/plugins/ and custom plugins in $ZSH_CUSTOM/plugins/
plugins=(
  aws
  poetry
  zoxide
  zsh-autosuggestions
)
alias cat="bat"
export BAT_THEME="base16"
export FZF_DEFAULT_COMMAND='fd --type f'
eval "$(zoxide init zsh)"

source $ZSH/oh-my-zsh.sh

########################################################
# Useful stuff
########################################################
alias ez="code ~/.zshrc"
alias nz="nvim ~/.zshrc"
alias sz="source ~/.zshrc"
alias cz="cat ~/.zshrc"
function rz() { rg $1 ~/.zshrc ${@:2}; }

alias nn="nvim ~/.config/nvim/init.lua"
alias cn="cat ~/.config/nvim/init.lua"

alias fmt="terraform fmt -recursive ."
alias l1="ls -1"
alias wipe_cache='docker builder prune -af'
alias wipe_containers='docker rm -vf $(docker ps -aq)'
alias wipe_images='docker rmi -f $(docker images -aq)'

update_dotfiles() {
  cp ~/.zprofile ~/yusufmahtab/dotfiles/.zprofile
  cp ~/.zshenv ~/yusufmahtab/dotfiles/.zshenv
  cp ~/.zshrc ~/yusufmahtab/dotfiles/.zshrc
  cp ~/.config/nvim/init.lua ~/yusufmahtab/dotfiles/init.lua
  cp ~/.p10k.zsh ~/yusufmahtab/dotfiles/.p10k.zsh
}

########################################################
# AWS
########################################################
alias aws_yusuf="source ~/.aws/yusuf"
alias ecr_authenticate="aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 131063299351.dkr.ecr.eu-west-1.amazonaws.com"

export AWS_DEFAULT_REGION=eu-west-1
generate_aws_credentials() {
  if [[ -n "$3" && "$3" == "elevated" ]]; then
    role="PlatformEngineerElevated"
    profile="$2-elevated"
  else
    role="PlatformEngineer"
    profile="$2"
  fi

  okta_aws -d 10800 -u yusuf.mahtab -r $role -a $1 -p $profile
  export AWS_PROFILE=$profile
}

alias          legacy="generate_aws_credentials 755865716437 legacy"
alias             ops="generate_aws_credentials 131063299351 ops"
alias         ops-dev="generate_aws_credentials 877470705970 ops-dev"
alias          master="generate_aws_credentials 587571228087 master"
alias      production="generate_aws_credentials 341175100383 production"
alias         staging="generate_aws_credentials 313303557381 staging"
alias             uat="generate_aws_credentials 058180101585 uat"

alias data-production="generate_aws_credentials 487284189313 data-production"
alias    data-staging="generate_aws_credentials 664780367565 data-staging"
alias   data-prod-dev="generate_aws_credentials 145953991976 data-prod-dev"
alias        data-uat="generate_aws_credentials 757539620829 data-uat"
alias data-playground="generate_aws_credentials 384215217813 data-playground"

########################################################
# Git
########################################################
export HOMEBREW_GITHUB_API_TOKEN="$(cat ~/.homebrew_github_api_token)"

alias gbd="git branch -D"
alias gch="git checkout"
alias gcm="git commit -m"
alias gl="git log --format=oneline --graph"
alias gpf="git push -f"
alias gpl="git pull"
alias gst="git status"

gacmp() {
  git add .
  git commit -a -m "$1"
  git push
}

gacp() {
  git add .
  git commit --amend --no-edit
  git push -f
}

git_main_branch() {
  if git show-ref -q --verify refs/remotes/origin/main; then
    echo main && return
  fi
  echo master
}

gupdate() {
  git pull --rebase origin $(git_main_branch)
  git push --force-with-lease
}

squash() {
  git rebase -i $(git_main_branch)
}

gclone() {
  git clone https://github.com/FundingCircle/$1.git
}

########################################################
# virtualenvwrapper
########################################################
# export PYTHON_VERSION=$(pyenv global)
# export WORKON_HOME=~/.virtualenvs
# export VIRTUALENVWRAPPER_VIRTUALENV=~/.pyenv/versions/$PYTHON_VERSION/bin/virtualenv
# export VIRTUALENVWRAPPER_PYTHON=~/.pyenv/versions/$PYTHON_VERSION/bin/python
# source ~/.pyenv/versions/$PYTHON_VERSION/bin/virtualenvwrapper.sh

########################################################
# dbt
########################################################
export DBT_PROFILES_DIR=.
export DBT_USER=yusuf_mahtab
alias dbt_build="docker build -t ${PWD##*/} . --target default --build-arg GITHUB_TOKEN=$HOMEBREW_GITHUB_API_TOKEN"
alias dbt_run="docker run -it -v ~/.aws/:/home/app-user/.aws -e AWS_PROFILE=production ${PWD##*/} sh"

########################################################
# Rancher Desktop
########################################################
export PATH="/Users/yusuf.mahtab/.rd/bin:$PATH"

# kubectl freaks out if the context != rancher-desktop, so use the one from brew instead
alias fix_k="test -f ~/.rd/bin/kubectl && mv ~/.rd/bin/kubectl ~/.rd/bin/formerly-kubectl"
fix_k

# datahub docker quickstart needs this
alias link_docker='echo "sudo ln -s .rd/docker.sock /var/run/docker.sock"'

# Some apps (like act) use DOCKER_HOST to look for docker
alias set_docker_host="export DOCKER_HOST=$(docker context inspect --format '{{.Endpoints.docker.Host}}')"

########################################################
# Kubernetes
########################################################
alias k="kubectl"
alias kx="kubectx"
alias kn="kubens"
source <(kubectl completion zsh)

alias k8s-show-ns="kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -n"

########################################################
# Other tooling
########################################################

export PATH="$HOME/go/bin:$PATH" # Go
export PATH="$HOME/.local/bin:$PATH" # Poetry
eval "$(rbenv init -)" # rbenv
export GPG_TTY=$(tty) # GPG key
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" # iTerm2
source ~/.okta_creds # Okta
source ~/.artifactory # Artifactory
