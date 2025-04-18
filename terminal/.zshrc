# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export http_proxy=http://127.0.0.1:10808
export https_proxy=http://127.0.0.1:10808
source "$HOME/.zshrc_pri"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
fi

# 检查并安装 zoxide
if ! command -v zoxide &> /dev/null; then
    echo "zoxide 未安装，正在尝试使用 apt 安装..."
    sudo apt update && sudo apt install -y zoxide fzf
fi

# 初始化 zoxide
autoload -U compinit && compinit -u
eval "$(zoxide init zsh --cmd j)" # j <dir> 快速跳转

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# 移除重复的zinit annexes配置

# 语法高亮（延迟加载）
zinit ice lucid wait='1' atinit='zpcompinit'
zinit light zdharma-continuum/fast-syntax-highlighting

# 自动建议（延迟加载）
zinit ice lucid wait="1" atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# 补全（延迟加载）
zinit ice lucid 


##################################################
# 加载 OMZ 框架及部分插件
##################################################
# zinit ice lucid wait='1'
# zinit snippet OMZ::lib/completion.zsh

# zinit ice lucid wait='1'
# zinit snippet OMZ::lib/history.zsh

# zinit ice lucid wait='1'
# zinit snippet OMZ::lib/theme-and-appearance.zsh

# zinit ice lucid wait='1'
# zinit snippet OMZ::plugins/autojump/autojump.plugin.zsh

# zinit ice lucid wait='1'
# zinit snippet OMZ::plugins/command-not-found/command-not-found.plugin.zsh

zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/theme-and-appearance.zsh
# zinit snippet OMZ::plugins/autojump/autojump.plugin.zsh

# zinit light-mode load OMZ::lib/completion.zsh
# zinit light-mode load OMZ::lib/history.zsh
# zinit light-mode load OMZ::lib/theme-and-appearance.zsh
# zinit light-mode load OMZ::plugins/autojump/autojump.plugin.zsh
# zinit light-mode wait'0' load OMZ::plugins/command-not-found/command-not-found.plugin.zsh


bindkey '^k' history-search-backward
bindkey '^j' history-search-forward
#
# 异步加载插件
zinit ice lucid wait='1'
zinit load zdharma/history-search-multi-word

zinit ice lucid wait='1'
zinit load djui/alias-tips

# zinit ice lucid wait='0'  # powerlevel10k需要立即加载以保证提示符显示
zinit load romkatv/powerlevel10k

#zinit wait lucid light-mode \
	  #atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
		#for marlonrichert/zsh-autocomplete

#zinit wait lucid light-mode \
	  #atinit"zstyle ':autocomplete:*' groups 'always'" \
		#atinit"zstyle ':autocomplete:(slash|space):*' magic 'off'" \
		  #for marlonrichert/zsh-autocomplete
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias curlp="curl -x http://127.0.0.1:10808"
alias wgetp="wget -e http_proxy='http://127.0.0.1:10808'"

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
alias vim=nvim
#alias grmadd="git remote add origin https://yuanbi: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@github.com/"
#alias grmadd="git remote add origin https://biyuan:PqJuwFA_ZNwS7d3s6GL8@git.51gonggui.com/"

#VIRTUAL_ENV_DISABLE_PROMPT="true"
#
#  移除重复的命令历史
setopt HIST_IGNORE_ALL_DUPS
# 设置历史记录的最大数量为100条以加快加载
HISTSIZE=300
SAVEHIST=300

# export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:'
export LS_COLORS='di=34;1:ln=36;1:so=32;1:pi=33;1:ex=31;1:bd=34;46;1:cd=34;43;1:su=30;41;1:sg=30;46;1:tw=30;42;1:ow=30;43;1:'

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# 移除任何可能存在的 zi 别名以避免冲突
unalias zi 2>/dev/null

