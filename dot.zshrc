# 基本設定
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8

# 補完機能
autoload -Uz compinit
compinit

# 色設定
autoload -Uz colors
colors

# ヒストリー設定
HISTFILE=$HOME/.zsh/zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt append_history       # 履歴を追加 (上書きしない)
setopt extended_history     # 履歴を追加 (上書きしない)
setopt hist_expand          # 履歴を展開
setopt hist_ignore_all_dups # 重複を記録しない
setopt hist_ignore_dups     # 重複を記録しない
setopt hist_ignore_space    # スペースで始まるコマンドを記録しない
setopt hist_reduce_blanks   # 空白を削除して記録
setopt hist_save_no_dups    # 重複を記録しない
setopt hist_verify          # ヒストリを呼び出してから実行する前に一旦編集可能
setopt inc_append_history   # 履歴を追加 (上書きしない)
setopt noautoremoveslash    # スラッシュを削除しない
setopt share_history        # 履歴を共有

# Ctrl+rでヒストリーのインクリメンタルサーチ、Ctrl+sで逆順
bindkey '^r' history-incremental-pattern-search-backward
bindkey '^s' history-incremental-pattern-search-forward

# 区切り文字の設定
autoload -Uz select-word-style
select-word-style default
#zstyle ':zle:*' word-chars "/;@ "
#zstyle ':zle:*' word-chars "_-./;@"
zstyle ':zle:*' word-chars " '\"/=;@:{}[]()<>,|."
zstyle ':zle:*' word-style unspecified

# Ctrl+sのロック, Ctrl+qのロック解除を無効にする
setopt no_flow_control

# 補完後、メニュー選択モードになり左右キーで移動が出来る
zstyle ':completion:*:default' menu select=2

# コマンドを途中まで入力後、historyから絞り込み
# 例 ls まで打ってCtrl+pでlsコマンドをさかのぼる、Ctrl+bで逆順
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^b" history-beginning-search-forward-end

autoload -Uz zmv
alias al='ls -al'
alias cgrep='grep --color=always'
alias dir='dir --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -a'
alias la='ls -A'
alias ll='ls -alF'
alias ll='ls -la'
alias ls='ls --color=auto'
alias ls='ls --group-directories-first --color=auto'
alias lu='ls -U1'
alias open='xdg-open'
alias s='screen -DRR'
alias vdir='vdir --color=auto'
alias zmv='noglob zmv -W'

# プロンプト設定
PROMPT="%{${fg[green]}%}%n@%m%{${reset_color}%} %{${fg[cyan]}%}%~%{${reset_color}%} %# "

# ディレクトリスタック
setopt auto_pushd
setopt pushd_ignore_dups

# キーバインディング
bindkey -e

# パス設定
typeset -U path cdpath fpath manpath

# その他の便利な設定
setopt correct              # コマンドのスペルミスを修正
setopt no_beep             # ビープ音を鳴らさない
setopt auto_cd             # ディレクトリ名だけでcd
setopt extended_glob       # 拡張グロブを有効化 

export VISUAL=vim
export EDITOR="$VISUAL"
export LESSCHARSET=utf-8

# git設定
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' use-simple true

# -- local env
export PATH="$HOME/zsh/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.vim/bin:$PATH"
export PATH="$HOME/.local/share/JetBrains/Toolbox/scripts:$PATH"

# -------------------------------------------
# clean up and normalize the PATH.
# -------------------------------------------
eval export "$( LC_ALL=C perl -CIO ~/dotfiles/organize_path.pl )"

ffg() {
  find ! -type d -print0 | xargs -0 grep --binary-files=without-match "$@"
}

cffg() {
  find -maxdepth 2 ! -type d -print0 | xargs -0 grep --binary-files=without-match "$@"
}

effg() {
  find -type d \( -name 'node_modules' -o -name '.git' -o -name 'public' -o -name 'storage' -o -name 'docs' -o -name '.tmp' \) -prune -o -type f -print0 | xargs -0 grep --binary-files=without-match "$@"
}

jffg() {
  find -type d \( -name 'node_modules' -o -name '.git' -o -name 'framework' -o -name '.tmp' \) -prune -o -type f -name '*.java' -print0 | xargs -0 grep --binary-files=without-match "$@"
}

pffg() {
  find -type d \( -name 'node_modules' -o -name '.git' -o -name 'public' \
    -o -name 'storage' -o -name 'docs' -o -name 'libraries' -o -name 'vendor' -o -name '.tmp' \) -prune -o -type f -name '*.php' -print0 | xargs -0 grep --binary-files=without-match "$@"
}

rffg() {
  find -type d \( -name 'node_modules' -o -name '.git' -o -name 'public' -o -name 'out' \
    -o -name 'storage' -o -name 'docs' -o -name 'libraries' -o -name 'vendor' -o -name '.tmp' \) -prune -o -type f -name '*.rb' -print0 | xargs -0 grep --binary-files=without-match "$@"
}

ccol() {
  cut -c1-${COLUMNS}
}

cls() {
  if builtin type banner >/dev/null 2>&1; then
    banner --width=$(tput cols) $(date "+%Y-%m-%d-%H:%M")
  fi
  perl -e 'print "\n"x`tput lines`'
}

ex() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1       ;;
      *.tar.gz)    tar xzf $1       ;;
      *.bz2)       bunzip2 $1       ;;
      *.rar)       unrar x $1       ;;
      *.gz)        gunzip $1        ;;
      *.tar)       tar xf $1        ;;
      *.tbz2)      tar xjf $1       ;;
      *.tgz)       tar xzf $1       ;;
      *.zip)       unzip -u sjis $1 ;;
      *.Z)         uncompress $1    ;;
      *.7z)        7z x $1          ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

reload() {
  exec "${SHELL}" "$@"
}

termtitle() {
  case "$TERM" in
    rxvt*|xterm*|nxterm|gnome|screen|screen-*|st|st-*)
      local prompt_host="${(%):-%m}"
      local prompt_user="${(%):-%n}"
      local prompt_char="${(%):-%~}"
      case "$1" in
        precmd)
          printf '\e]0;%s@%s: %s\a' "${prompt_user}" "${prompt_host}" "${prompt_char}"
          ;;
        preexec)
          printf '\e]0;%s [%s@%s: %s]\a' "$2" "${prompt_user}" "${prompt_host}" "${prompt_char}"
          ;;
      esac
      ;;
  esac
}

precmd()
{
  termtitle precmd
  vcs_info
}

preexec()
{
  termtitle preexec "${(V)1}"
}

PERIOD=600
periodic()
{
  # gitコマンドがあるか確認する
  if ! builtin command -v git >/dev/null 2>&1; then
    return
  fi

  # gitリポジトリ内であるか確認する
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    local stashes="$(git stash list)"
    if [ -n "${stashes}" ]; then
      echo "----------------------------------------"
      echo -e "\033[34m"
      echo "${stashes}"
      echo -e "\033[m"
      echo ""
    fi
  fi
}

PROMPT='${vcs_info_msg_0_}[%n@%m %1~]$ '

[ -e $HOME/.zsh/localrc ] && . $HOME/.zsh/localrc
