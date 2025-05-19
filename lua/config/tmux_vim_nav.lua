vim.cmd([[
function! s:VimNavigate(direction)
  if winnr() !=# winnr(a:direction)
    execute 'wincmd ' . a:direction
  else
    if a:direction == 'h'
      call system('tmux select-pane -L')
    elseif a:direction == 'j'
      call system('tmux select-pane -D')
    elseif a:direction == 'k'
      call system('tmux select-pane -U')
    elseif a:direction == 'l'
      call system('tmux select-pane -R')
    endif
  endif
endfunction

command! Vnleft call s:VimNavigate('h')
command! Vnright call s:VimNavigate('l')
command! Vnup call s:VimNavigate('k')
command! Vndown call s:VimNavigate('j')
]])
