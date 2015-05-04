" splice.vim - integrate with tmux

if exists("g:loaded_splice") || v:version < 700 || &cp
  finish
endif
let g:loaded_splice = 1

function! s:SetTarget()
  let s:target = input("Enter target: ")
endfunction

function! s:Target()
  return s:target
endfunction

function! s:ListSessions()
  return system("tmux list-sessions -F '#{session_name}'")
endfunction

function! s:CompleteSession(A,L,P)
  return s:ListSessions()
endfunction

command! SetTarget  call s:SetTarget()
command! ShowTarget echo "Target is " . s:Target()
command! -nargs=+ CompleteSession echo s:CompleteSession(<f-args>)

