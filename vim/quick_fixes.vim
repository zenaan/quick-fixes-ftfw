function! quick_fixes#Toggle_max_line_indicator()
	" Toggle max_line_indicator between "" and current value of &colorcolumn (or "+1" if it's not set)
	" cc is alias for colorcolumn
	" colorcolumn applies to the current Vim "window"

	if (!exists('w:max_line_indicator_prev'))  " initialize max_line_indicator_prev
		if &colorcolumn == ""
			let w:max_line_indicator_prev = "+1"
		else
			let w:max_line_indicator_prev = ""
		endif
	endif
	let newprev = &colorcolumn
	let &colorcolumn = w:max_line_indicator_prev
	let w:max_line_indicator_prev = newprev
	set colorcolumn
endfunction

