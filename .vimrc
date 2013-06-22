
" ------------------------------------------------------------
" 初期化処理
" ------------------------------------------------------------

" NeoBundle がインストールされていない時、
" もしくは、プラグインの初期化に失敗した時の処理
function! s:WithoutBundles()
	colorscheme desert
endfunction

" NeoBundle がインストールされているなら LoadBundles() を呼び出す
" そうでないなら WithoutBundles() を呼び出す
if isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
	filetype plugin indent off
	if has('vim_starting')
		set runtimepath+=~/.vim/bundle/neobundle.vim/
	endif
	try
		call neobundle#rc(expand('~/.vim/bundle/'))
	catch
		call s:WithoutBundles()
	endtry 
else
	call s:WithoutBundles()
endif

" プラグインの読み込み
source ~/dotfiles/.vimrc.neobundle

" Vim設定の読み込み
source ~/dotfiles/.vimrc.basic

" 補完機能の設定
source ~/dotfiles/.vimrc.complete

" LaTeX設定
source ~/dotfiles/.vimrc.latex

" 見た目の変更
source ~/dotfiles/.vimrc.appearance

" Unite設定の読み込み
source ~/dotfiles/.vimrc.unite

" キーマッピング
source ~/dotfiles/.vimrc.mapping


