
"------------------------------------------------------
" TeX用設定
"------------------------------------------------------

function! s:LoadVimLaTexSetting()
	filetype plugin on
	filetype indent on

	set shellslash
	set grepprg=grep\ -nH\ $*

	let g:tex_flavor                      = 'latex'
	let g:Imap_UsePlaceHolders            = 1
	let g:Imap_DeleteEmptyPlaceHolders    = 1
	let g:Imap_StickyPlaceHolders         = 0
	let g:Tex_DefaultTargetFormat         = 'pdf'
	let g:Tex_FormatDependency_ps         = 'dvi,ps'
	let g:Tex_FormatDependency_pdf        = 'dvi,pdf'
	let g:Tex_CompileRule_dvi             = 'platex -synctex=1 -src-specials -interaction=nonstopmode $*'
	let g:Tex_CompileRule_ps              = 'dvips -Ppdf -t a4 -o $*.ps $*.dvi'
	let g:Tex_CompileRule_pdf             = 'dvipdfmx $*.dvi'
	let g:Tex_BibtexFlavor                = 'pbibtex'
	let g:Tex_MakeIndexFlavor             = 'mendex $*.idx'
	let g:Tex_UseEditorSettingInDVIViewer = 1
	let g:Tex_ViewRule_dvi                = 'pxdvi -nofork -watchfile 1 -editor "vim --servername vim-latex -n --remote-silent +\%l \%f"'
	let g:Tex_ViewRule_dvi                = 'advi -watch-file 1'
	let g:Tex_ViewRule_dvi                = 'evince'
	let g:Tex_ViewRule_dvi                = 'okular --unique'
	let g:Tex_ViewRule_dvi                = 'wine ~/.wine/drive_c/w32tex/dviout/dviout.exe -1'
	let g:Tex_ViewRule_ps                 = 'gv --watch'
	let g:Tex_ViewRule_ps                 = 'evince'
	let g:Tex_ViewRule_ps                 = 'okular --unique'
	let g:Tex_ViewRule_pdf                = 'texworks'
	let g:Tex_ViewRule_pdf                = 'gv --watch'
	let g:Tex_ViewRule_pdf                = 'evince'
	let g:Tex_ViewRule_pdf                = 'okular --unique'
	let g:Tex_ViewRule_pdf                = 'zathura'
endfunction


"------------------------------------------------------
" 補完設定
"------------------------------------------------------

function! s:LoadNeoComplSetting()
	filetype plugin on
	filetype indent off

	" 補完ウィンドウの設定
	set completeopt=menuone

	" 起動時に有効化
	let g:neocomplcache_enable_at_startup            = 1

	" 大文字が入力されるまで大文字小文字の区別を無視する
	let g:neocomplcache_enable_smart_case            = 1

	" _(アンダースコア)区切りの補完を有効化
	let g:neocomplcache_enable_underbar_completion   = 1

	" キャメルケースでの補完有効化
	let g:neocomplcache_enable_camel_case_completion = 1

	" ポップアップメニューで表示される候補の数
	let g:neocomplcache_max_list                     = 20

	" シンタックスをキャッシュするときの最小文字長
	let g:neocomplcache_min_syntax_length            = 3

	if !exists('g:neocomplcache_keyword_patterns')
		let g:neocomplcache_keyword_patterns = {}
	endif
	let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

	" スニペットを展開する
	imap <C-e> <Plug>(neosnippet_expand_or_jump)
	smap <C-e> <Plug>(neosnippet_expand_or_jump)

	" 前回行われた補完をキャンセルします
	inoremap <expr><C-g> neocomplcache#undo_completion()

	" 補完候補のなかから、共通する部分を補完します
	inoremap <expr><C-l> neocomplcache#complete_common_string()

	"tabで補完候補の選択を行う
	inoremap <expr><TAB>   pumvisible() ? "\<Down>" : "\<TAB>"
	inoremap <expr><S-TAB> pumvisible() ? "\<Up>"   : "\<S-TAB>"

	" <C-h>や<BS>を押したときに確実にポップアップを削除します
	inoremap <expr><C-h> neocomplcache#smart_close_popup().”\<C-h>”

	" 現在選択している候補をキャンセルし、ポップアップを閉じます
	inoremap <expr><C-x><C-q> neocomplcache#cancel_popup()

	" --------------------------------------------------------
	" C言語用補完機能設定
	" --------------------------------------------------------

	" clang_completeのための設定
	" neocomplcache 側の設定
	let g:neocomplcache_force_overwrite_completefunc=1

	if !exists("g:neocomplcache_force_omni_patterns")
		let g:neocomplcache_force_omni_patterns = {}
	endif

	" omnifunc が呼び出される場合の正規表現パターンを設定しておく
	let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|::'

	" clang_complete 側の設定
	" clang_complete の自動呼び出しは必ず切っておいて下さい
	" これを設定しておかなければ補完がおかしくなります
	"let g:clang_complete_auto=0
	let g:clang_complete_auto = 1 
	let g:clang_use_library   = 1 
	let g:clang_library_path  = '/usr/lib/'
	let g:clang_user_options  = '2>/dev/null || exit 0"'
endfunction


" ------------------------------------------------------------
" NeoBundle よるプラグインのロード
" ------------------------------------------------------------

" プラグインの読み込み
function! s:LoadBundles()
	NeoBundle 'vim-jp/vimdoc-ja'

	NeoBundle 'Shougo/neobundle.vim'
	NeoBundle 'Shougo/neocomplcache'
	NeoBundle 'Shougo/neosnippet'
	NeoBundle 'Shougo/unite.vim'
	NeoBundle 'Shougo/unite-outline'
	NeoBundle 'Shougo/vimfiler.git'
	NeoBundle 'Shougo/vimshell'
	NeoBundle 'Shougo/vimproc',{ 'build' : {
				\'cygwin' : 'make -f make_cygwin.mak',
				\'unix' : 'make -f make_unix.mak',
				\},
				\}
	"after install, turn shell ~/.vim/bundle/vimproc, 
	"(n,g)make -f your_machines_makefile

	NeoBundle 'tpope/vim-surround'
	NeoBundle 'thinca/vim-fontzoom'
	NeoBundle 'h1mesuke/vim-alignta'

	NeoBundle 'TagHighlight'
	NeoBundle 'DoxygenToolkit.vim'

	NeoBundle 'osyo-manga/neocomplcache-clang_complete'
	NeoBundle 'Rip-Rip/clang_complete'
	call s:LoadNeoComplSetting()

	NeoBundle 'git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex' 
	call s:LoadVimLaTexSetting()

	NeoBundle 'buffet.vim'

	" Gitのいろいろ
	NeoBundle 'tpope/vim-fugitive'

	" ステータスバーかっこ良く機能的に
	NeoBundle 'Lokaltog/vim-powerline'

	" カラースキーマ
	NeoBundle 'altercation/vim-colors-solarized'
endfunction

" NeoBundle がインストールされていない時、
" もしくは、プラグインの初期化に失敗した時の処理
function! s:WithoutBundles()
	colorscheme desert
endfunction

" NeoBundle がインストールされているなら LoadBundles() を呼び出す
" そうでないなら WithoutBundles() を呼び出す
function! s:InitNeoBundle()
	if isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
		filetype plugin indent off
		if has('vim_starting')
			set runtimepath+=~/.vim/bundle/neobundle.vim/
		endif
		try
			call neobundle#rc(expand('~/.vim/bundle/'))
			call s:LoadBundles()
		catch
			call s:WithoutBundles()
		endtry 
	else
		call s:WithoutBundles()
	endif

	filetype indent plugin on
	syntax on
endfunction

function! s:LoadAligntaSettings()
	nnoremap [unite] <Nop>
	xnoremap [unite] <Nop>
	nmap f [unite]
	xmap f [unite]

	let g:unite_source_alignta_preset_arguments = [
				\ ["Align at '='", '=>\='],  
				\ ["Align at ':'", '01 :'],
				\ ["Align at '|'", '|'   ],
				\ ["Align at ')'", '0 )' ],
				\ ["Align at ']'", '0 ]' ],
				\ ["Align at '}'", '}'   ],
				\]

	let s:comment_leadings = '^\s*\("\|#\|/\*\|//\|<!--\)'
	let g:unite_source_alignta_preset_options = [
				\ ["Justify Left",      '<<' ],
				\ ["Justify Center",    '||' ],
				\ ["Justify Right",     '>>' ],
				\ ["Justify None",      '==' ],
				\ ["Shift Left",        '<-' ],
				\ ["Shift Right",       '->' ],
				\ ["Shift Left  [Tab]", '<--'],
				\ ["Shift Right [Tab]", '-->'],
				\ ["Margin 0:0",        '0'  ],
				\ ["Margin 0:1",        '01' ],
				\ ["Margin 1:0",        '10' ],
				\ ["Margin 1:1",        '1'  ],
				\
				\ 'v/' . s:comment_leadings,
				\ 'g/' . s:comment_leadings,
				\]
	unlet s:comment_leadings

	nnoremap <silent> [unite]a :<C-u>Unite alignta:options<CR>
	xnoremap <silent> [unite]a :<C-u>Unite alignta:arguments<CR>
endfunction


" ------------------------------------------------------------
" キーマップの設定
" ------------------------------------------------------------

function! s:VimKeymaps()
	" 行番号の表示
	set number

	" タブを表示するときの幅
	set tabstop=4
	" タブを挿入するときの幅
	set shiftwidth=4
	" タブをタブとして扱う(スペースに展開しない)
	set noexpandtab 
	set softtabstop=0

	" 左右移動で行跨ぎ
	set whichwrap=b,s,h,l,<,>,[,],~

	" 行移動を見た目上に行うようにしています。wrap指定している場合、
	" 見た目上は数行に改行されていても内部的には1行なので。
	noremap  j      gj
	noremap  k      gk
	nnoremap <Down> gj
	nnoremap <Up>   gk

	" 検索結果に移動したとき、その位置を画面の中央にします。
	nnoremap n  nzz
	nnoremap N  Nzz
	nnoremap *  *zz
	nnoremap #  #zz
	nnoremap g* g*zz
	nnoremap g# g#zz

	" 挿入モードでのカーソル移動
	" 下に移動
	inoremap <C-j> <Down>
	" 上に移動
	inoremap <C-k> <Up>
	" 左に移動
	inoremap <C-h> <Left>
	" 右に移動
	inoremap <C-l> <Right>

	" ファイラーを起動
	nnoremap <silent><C-x><C-f> :VimFiler<CR>

	" 前のバッファ、次のバッファ、バッファの削除、バッファのリスト
	nnoremap <silent><S-b> :bp<CR>
	nnoremap <silent><S-n> :bn<CR>
	nnoremap <silent><S-k> :bd<CR>
	nnoremap <silent><S-l> :Bufferlist<CR>

	" 一行追加
	nnoremap <silent><C-o> o<ESC>

	" アウトラインを表示
	nnoremap <silent><C-t> :Unite -vertical -winwidth=30 -no-quit outline<CR>

	" Ctrl s で保存などWindows系キーバインド(.bashrcなんかで$stty -ixon　-ixoffが必要)
	nnoremap <C-s> <ESC>:w<CR>
	inoremap <C-s> <ESC><ESC>:w<CR>i
	nnoremap <C-q> <ESC>:q!<CR>
	inoremap <C-q> <ESC>:q!<CR>

	" 日本語モードでもモード切り替えできるようにとか
	nnoremap <C-i> i
	nnoremap <C-v> v
	nnoremap <C-u> u
	nnoremap <C-p> p
	nnoremap <C-y> y
	nnoremap <C-*> :

	" Spaceでページ送り
	nnoremap <Space> <C-f> 

	" いきなり矩形選択
	nnoremap <C-v> v<C-v>

	" CTRL-C to copy (visual mode)
	vmap <C-c>     y
	imap <S-up>    <ESC>v
	imap <S-down>  <ESC>v
	imap <S-left>  <ESC>v
	imap <S-right> <ESC>v
	nmap <S-up>    <ESC>v
	nmap <S-down>  <ESC>v
	nmap <S-left>  <ESC>v
	nmap <S-right> <ESC>v

	" CTRL-X to cut (visual mode)
	vmap <C-x> x

	" CTRL-V to paste (insert mode)
	imap <C-v> <ESC>pi

	" Ctrl-Z to undo
	imap <C-z> <ESC>ui
	nmap <C-z> u

	" Doxygenコメントの追加
	nnoremap <C-d><C-x> :Dox<CR>
endfunction


" ------------------------------------------------------------
" ステータス行を表示して色々
" ------------------------------------------------------------

function! s:SetStatusLineAndColor()
	set laststatus=2
	syntax enable
	set background=dark
	colorscheme solarized
endfunction


" ------------------------------------------------------------
" 初期化処理
" ------------------------------------------------------------

function! s:Initialize()
	call s:InitNeoBundle()
	call s:VimKeymaps()
	"call s:SetStatusLineAndColor()
	set laststatus=2
endfunction

" ステータスバーカラー表示のため
set t_Co=256

call s:Initialize()
