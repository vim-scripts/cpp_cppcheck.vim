" Vim plugin to run Cppcheck on the current buffer.
" Last Change:	2015 May 29
" Maintainer:	Brendan Robeson (https://github.com/brobeson/Tools)
" License:		Public Domain

" check if this plugin (or one with the same name) has already been loaded
if exists('b:loaded_cpp_cppcheck')
	finish
endif
let b:loaded_cpp_cppcheck = 1

" save cpoptions and reset to avoid problems in the script
let s:save_cpo = &cpo
setlocal cpo&vim


" ensure that the options and path variables have been defined. if the
" user hasn't done so, set them up with defaults
if !exists('g:cpp_cppcheck_options')
	let g:cpp_cppcheck_options = ''
endif

" add to the error format, so the quick fix window can be used
setlocal efm+=\[%f:%l\]:\ %m

" create the command to run Cppcheck
if !exists(':Cppcheck')
	command -buffer Cppcheck :call s:RunCppcheck()
endif

" the function to do the work
if !exists('*s:RunCppcheck')
	function s:RunCppcheck()
		if executable('cppcheck') == 0
			echo 'Cppcheck cannot be found. Ensure the path to cppcheck is in your PATH environment variable.'
		else
			let cmd = 'silent !cppcheck ' . g:cpp_cppcheck_options . ' ' . expand('%:p') . ' 2> ' . &errorfile
			execute cmd
			cgetfile
			copen
		endif
	endfunction
endif


" restore the original cpoptions
let &cpo = s:save_cpo
unlet s:save_cpo

