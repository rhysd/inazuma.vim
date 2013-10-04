if exists('g:loaded_inazuma')
    finish
endif

command! -count=2 -nargs=0 -bang Inazuma call inazuma#this(<count>, <bang>0)
command! -count=2 -nargs=0 -bang InazumaOnly call inazuma#this(<count>, <bang>0)
command! -count=2 -nargs=0 -bang InazumaZoomWin call inazuma#this(<count>, <bang>0)
command! -nargs=0 InazumaAdujust call inazuma#adjust()

augroup inazuma
    autocmd!
augroup END

let g:loaded_inazuma = 1
