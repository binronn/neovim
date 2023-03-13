#source ~/.bashrc
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 添加 wsl2 代理支持
hostdnsfile=/mnt/wsl/resolv.conf
if [ -f "$hostdnsfile" ]; then
    hostip=`cat /mnt/wsl/resolv.conf | grep nameserver | awk -v hostip=$2 '{print $2}'`
else
    hostip=127.0.0.1
fi

# Add to PATH
export PATH=$PATH:$(pwd)/.local/bin

export http_proxy="http://$hostip:10808"
export https_proxy="http://$hostip:10808"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# 语法高亮
zinit ice lucid wait='0' atinit='zpcompinit'
zinit light zdharma-continuum/fast-syntax-highlighting

# 自动建议
zinit ice lucid wait="0" atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# 补全
zinit ice lucid wait='0'
zinit light zsh-users/zsh-completions

# 加载 OMZ 框架及部分插件
zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/theme-and-appearance.zsh
zinit snippet OMZ::plugins/autojump/autojump.plugin.zsh
zinit snippet OMZ::plugins/command-not-found/command-not-found.plugin.zsh

bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
#
zinit ice lucid wait='0'
zinit load zdharma/history-search-multi-word
zinit ice lucid wait='0'
zinit load djui/alias-tips

# 终端美化
zinit ice depth=1
zinit light romkatv/powerlevel10k

#zinit wait lucid light-mode \
	  #atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        #for marlonrichert/zsh-autocomplete

#zinit wait lucid light-mode \
	  #atinit"zstyle ':autocomplete:*' groups 'always'" \
        #atinit"zstyle ':autocomplete:(slash|space):*' magic 'off'" \
          #for marlonrichert/zsh-autocomplete

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# alias curlp="curl -x http://$hostip:10808"
# alias wgetp="wget -e http_proxy='http://$hostip:10808'"

alias ga="git add"
alias gaa="git add ."
alias gct="git commit"
alias gcm="git commit -m"
alias gph="git push"
alias gpl="git pull"
alias gss="git status"
alias gsh="git stash"
alias gct="git checkout"
alias gbh="git branch"
alias grt="git remote"
alias gdf="git diff"
alias gl="git log"
alias gcl="git clone"
alias vim=nvim
#alias grmadd="git remote add origin https://yuanbi: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@github.com/"
#alias grmadd="git remote add origin https://biyuan:PqJuwFA_ZNwS7d3s6GL8@git.51gonggui.com/"

#VIRTUAL_ENV_DISABLE_PROMPT="true"
#
#  移除重复的命令历史
setopt HIST_IGNORE_ALL_DUPS

