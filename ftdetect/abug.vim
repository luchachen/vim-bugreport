fun! s:DetectLogcat()
	" Detect from first line
	if getline(2) =~# '== dumpstate:'
		set filetype=abug
	endif
endfun

au BufNewFile,BufRead *.bugreport set filetype=abug
au BufNewFile,BufRead * call s:DetectLogcat()
set fdm=syntax
