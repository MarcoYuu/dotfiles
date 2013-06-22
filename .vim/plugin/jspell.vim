" Jspell            ver0.01 [2012-01-07] start
" " need chasen
" " sudo apt-get install chasen
"
" 呼び出し
vnoremap <silent>  <leader>s :call  Jspell()<cr>

" 再読み込み防止
if exists("g:loaded_jspell")
	finish
endif

let g:loaded_jspell = 1

let s:save_cpo = &cpo
set cpo&vim

function! s:GetVrange()
	let l:tmp = @@
	silent normal gvy
	let l:select = @@
	let @@ = l:tmp
	return l:select
endfunction

function! Jspell() range
	let l:selected = <SID>GetVrange()
	execute "tabe "
	call append(line("."), split(system("chasen -F '%m '", l:selected), "\n"))
	execute "set spell"
	unlet! l:selected
endfunction 

let &cpo = s:save_cpo
