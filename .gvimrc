source $VIMRUNTIME/delmenu.vim
set langmenu=ja_jp.utf-8
source $VIMRUNTIME/menu.vim

if has('win32') || has('win64')
	set guifont=Consolas:h10.5
	set guifontwide=MeiryoKe_Console:h10.5
else
	" Consolas\ for\ Powerline\ 11
	" ああああああああ
	set guifont=Consolas\ for\ Powerline\ 11
	set guifontwide=Ricty\ for\ Powerline\ 12
	set linespace=1
endif

set novisualbell
set noerrorbells
set visualbell t_vb=

set guioptions-=T
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
set guioptions-=b

colorscheme zenburn_mod
