# 文字コードの設定
export LANG=ja_JP.UTF-8

## 履歴の保存先
HISTFILE=$HOME/.zsh-history
## メモリに展開する履歴の数
HISTSIZE=100000
## 保存する履歴の数
SAVEHIST=100000

## 補完機能の強化
autoload -U compinit
compinit

## コアダンプサイズを制限
limit coredumpsize 102400
## 出力の文字列末尾に改行コードが無い場合でも表示
unsetopt promptcr
## Emacsライクキーバインド設定
bindkey -e

## 色を使う
setopt prompt_subst
## ビープを鳴らさない
setopt nobeep
## 内部コマンド jobs の出力をデフォルトで jobs -l にする
setopt long_list_jobs
## 補完候補一覧でファイルの種別をマーク表示
setopt list_types
## サスペンド中のプロセスと同じコマンド名を実行した場合はリジューム
setopt auto_resume
## 補完候補を一覧表示
setopt auto_list
## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups
## cd 時に自動で push
setopt auto_pushd
## 同じディレクトリを pushd しない
setopt pushd_ignore_dups
## ファイル名で #, ~, ^ の 3 文字を正規表現として扱う
setopt extended_glob
## TAB で順に補完候補を切り替える
setopt auto_menu
## zsh の開始, 終了時刻をヒストリファイルに書き込む
setopt extended_history
## =command を command のパス名に展開する
setopt equals
## --prefix=/usr などの = 以降も補完
setopt magic_equal_subst
## ヒストリを呼び出してから実行する間に一旦編集
setopt hist_verify
## ファイル名の展開で辞書順ではなく数値的にソート
setopt numeric_glob_sort
## 出力時8ビットを通す
setopt print_eight_bit
## ヒストリを共有
setopt share_history
## 補完時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## 補完候補のカーソル選択を有効に
zstyle ':completion:*:default' menu select=1
## 補完候補の色づけ
eval `dircolors`
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
## ディレクトリ名だけで cd
setopt auto_cd
## カッコの対応などを自動的に補完
setopt auto_param_keys
## ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash
## スペルチェック
setopt correct
## {a-c} を a b c に展開する機能を使えるようにする
setopt brace_ccl
## Ctrl+S/Ctrl+Q によるフロー制御を使わないようにする
setopt no_flow_control
## コマンドラインの先頭がスペースで始まる場合ヒストリに追加しない
setopt hist_ignore_space
## コマンドラインでも # 以降をコメントと見なす
setopt interactive_comments
## ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt mark_dirs
## history (fc -l) コマンドをヒストリリストから取り除く。
setopt hist_no_store
# 余分なスペースを削除してヒストリに記録する
setopt hist_reduce_blanks
## 補完候補を詰めて表示
setopt list_packed
## 最後のスラッシュを自動的に削除しない
setopt noautoremoveslash
# 補完するかの質問は画面を超える時にのみに行う｡
LISTMAX=0
# sudo でも補完の対象
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
# ビープ音を鳴らさないようにする
setopt no_beep
# auto_list の補完候補一覧で、ls -F のようにファイルの種別をマーク表示しない
setopt no_list_types
# Ctrl+wで､直前の/までを削除する｡
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
# ファイルリスト補完でもlsと同様に色をつける｡
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}



# PATH
export PATH=~/bin:${PATH}

# aliases
alias ll='ls -alF'
alias la='ls -AF'
alias l='ls -CF'
alias ls='ls -pF --color=auto'
alias diff=colordiff
alias emacs='XMODIFIERS=@im=none emacs'

# less syntax hightlight
export LESS='-R'
export LESSOPEN='| $HOME/bin/src-hilite-lesspipe.sh %s'

# ssh X forwarding aliases
alias sshosore='ssh -X -Y momma@osore' 
alias sshhome='ssh -X -Y yuumomma@beafjerkyoishi.hobby.jp' 
alias sshtesla='ssh -X -Y momma@tesla' 
alias sshlab='ssh -X -Y momma@gate0.comp.sd.keio.ac.jp' 

# gcc切り替え
alias switchgcc='sudo update-alternatives --config gcc'

# Version Control System(vcs)の情報を出すようにする
autoload -Uz add-zsh-hook
autoload -Uz colors
colors
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' formats '%s:[%b]'
zstyle ':vcs_info:*' actionformats '%s:[%b|%a]'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true

autoload -Uz is-at-least
if is-at-least 4.3.10; then
	# この check-for-changes が今回の設定するところ
	zstyle ':vcs_info:git:*' check-for-changes true
	zstyle ':vcs_info:git:*' stagedstr "+"    # 適当な文字列に変更する
	zstyle ':vcs_info:git:*' unstagedstr "*"  # 適当の文字列に変更する
	zstyle ':vcs_info:git:*' formats '(%s)-[%b] %c%u'
	zstyle ':vcs_info:git:*' actionformats '(%s)-[%b|%a] %c%u'
fi

function _update_vcs_info_msg() {
psvar=()
LANG=en_US.UTF-8 vcs_info
[[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg

source ~/bin/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true

#RPROMPT="%1(v|%F{red}%1v%f|)"
RPROMPT="%1(v|%F{red}%1v%f|) %F{cyan}[%D %*]%f"
setopt transient_rprompt
PROMPT='%{%F{green}%B%n@%m%b%f:%F{blue}%~%f%F{red}%B$(__git_ps1)%b%f%#%} 
> '





