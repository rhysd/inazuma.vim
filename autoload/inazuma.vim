function! s:set_head_to(line)
    let scrollbind_save = &l:scrollbind
    let &l:scrollbind = 0

    let line_diff = line('w0') - a:line
    if line_diff > 0
        execute 'normal!' line_diff."\<C-y>"
    elseif line_diff < 0
        execute 'normal!' (-line_diff)."\<C-e>"
    endif

    let &l:scrollbind = scrollbind_save
endfunction

function! s:make_inazuma_window()
    let prev_winnr = winnr()
    let line = line('w$')
    let start_line_of_win = line == line('$') ? line : (line + 1)
    silent rightbelow vsplit
    call s:set_head_to(start_line_of_win)
    execute prev_winnr.'wincmd w'
    wincmd p
    setlocal scrollbind
    return winnr()
endfunction

function! s:disable_inazuma()
    let pos_save = getpos('.')
    for winnr in s:winn
        execute winnr.'wincmd w'
        set noscrollbind
    endfor
    call setpos('.', pos_save)

    unlet b:inazuma_is_enabled
    let s:winnrs = []
    autocmd! inazuma
endfunction

" TODO adjust considering 'wrap'
function! inazuma#adjust()
    " toggle
    if get(b:, 'inazuma_is_enabled', 0)
        call s:disable_inazuma()
        return
    endif

    let scrolloff_save = &scrolloff
    let &scrolloff = 0

    execute s:winnrs[0].'wincmd w'
    let start_line_of_win = line('$') + 1

    for winnr in s:winnrs[1:]
        execute winnr.'wincmd w'
        call s:set_head_to(start_line_of_win)
        let start_line_of_win = line('$') + 1
    endfor

    let &scrolloff = scrolloff_save

    augroup inazuma
        autocmd CursorMoved * call inazuma#adjust_at_cursor_moved()
        autocmd CursorMovedI * call inazuma#adjust_at_cursor_moved()
    augroup END
endfunction

function! inazuma#adjust_at_cursor_moved()
    let pos_save = getpos('.')
    try
        if get(b:, 'inazuma_is_enabled', 0)
            call inazuma#adjust()
        endif
    finally
        call setpos('.', pos_save)
    endtry
endfunction

" TODO compute most suitable number of split from window width
function! inazuma#this(num_split, bang)
    let b:inazuma_is_enabled = 1
    let s:winnrs = [winnr()]
    setlocal scrollbind
    for _ in range(a:num_split-1)
        call add(s:winnrs, s:make_inazuma_window())
    endfor
endfunction

function! inazuma#only(num_split, bang)
    throw "Not implemented yet"
endfunction

function! inazuma#zoomwin(num_split, bang)
    throw "Not implemented yet"
endfunction
