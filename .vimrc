
" 初期化処理 "{{{
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_mac = !s:is_windows && !s:is_cygwin
			\ && (has('mac') || has('macunix') || has('gui_macvim') ||
			\   (!executable('xdg-open') &&
			\     system('uname') =~? '^darwin'))
let s:is_sudo = $SUDO_USER != '' && $USER !=# $SUDO_USER
			\ && $HOME !=# expand('~'.$USER)
			\ && $HOME ==# expand('~'.$SUDO_USER)

if s:is_windows
	" Exchange path separator.
	set shellslash
endif
"}}}

" NeoBundleの読み込み "{{{
" git ある? "{{{
if !executable("git")
	echo "Please install git."
	finish
endif
"}}}

" NeoBundleがなかったらclone "{{{
if !isdirectory(expand("~/.vim/bundle/neobundle.vim"))
	echo "Please install neobundle.vim."
	function! s:install_neobundle()
		if input("Install neobundle.vim? [Y/N] : ") =="Y"
			if !isdirectory(s:neobundle_plugins_dir)
				call mkdir(s:neobundle_plugins_dir, "p")
			endif
			execute "!git clone git://github.com/Shougo/neobundle.vim "
						\ . "~/.vim/bundle/neobundle.vim"
			echo "neobundle installed. Please restart vim."
		else
			echo "Canceled."
		endif
	endfunction
	augroup install-neobundle
		autocmd!
		autocmd VimEnter * call s:install_neobundle()
	augroup END
	finish
endif
"}}}

" プラグインディレクトリの読み込み "{{{
if isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
	filetype plugin indent off
	if has('vim_starting')
		set runtimepath+=~/.vim/bundle/neobundle.vim/
	endif
	try
		call neobundle#rc(expand('~/.vim/bundle/'))
	catch
		echo "Error!"
		echo "NeoBundle is not working."
		finish
	endtry
else
	" NeoBundle がインストールされていない時、
	" もしくは、プラグインの初期化に失敗した時の処理
	echo "NeoBundle directory is not found."
	finish
endif
"}}}
"}}}

" 設定の読み込み "{{{

" プラグインの読み込み
source ~/dotfiles/.vimrc.neobundle

" Vim設定の読み込み
source ~/dotfiles/.vimrc.basic

" キーマッピング
source ~/dotfiles/.vimrc.mapping

" 見た目の変更
source ~/dotfiles/.vimrc.appearance

"}}}
