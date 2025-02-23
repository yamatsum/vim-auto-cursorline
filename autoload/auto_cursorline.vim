" When CursorMoved,CursorMovedI occurs, it substitutes s:cursor into s:status.
" And when WinEnter, it substitutes s:window into s:status.
"
" NOTE: When you enter in a new window, WinEnter AND CursorMoved events occur
" some time. So cursor_moved() does nothing when s:status == s:window, that
" is, win_enter() has been called. When you move the cursor after that, it
" sets 'nocursorline' at the first time.

let s:disabled = 0
let s:cursor = 1
let s:window = 2
let s:status = s:disabled
let s:timer_id = 0
let s:hicursor = '#2C313C'

setlocal cursorline
hi CursorLine guibg=none

function! auto_cursorline#cursor_moved() abort
  if s:status == s:window
    let s:status = s:cursor
    return
  endif
  call auto_cursorline#timer_stop()
  call auto_cursorline#timer_start()
  if s:status == s:cursor
    hi CursorLine guibg=none
    let s:status = s:disabled
  endif
endfunction

function! auto_cursorline#win_enter() abort
  setlocal cursorline
  exe 'hi CursorLine guibg=' . s:hicursor
  let s:status = s:window
  call auto_cursorline#timer_stop()
endfunction

function! auto_cursorline#win_leave() abort
  setlocal nocursorline
  hi CursorLine guibg=none
  call auto_cursorline#timer_stop()
endfunction

function! auto_cursorline#timer_start() abort
  let s:timer_id = timer_start(g:auto_cursorline_wait_ms, 'auto_cursorline#enable')
endfunction

function! auto_cursorline#timer_stop() abort
  if s:timer_id
    call timer_stop(s:timer_id)
    let s:timer_id = 0
  endif
endfunction

function! auto_cursorline#enable(timer_id) abort
  exe 'hi CursorLine guibg=' . s:hicursor
  let s:status = s:cursor
  let s:timer_id = 0
endfunction
