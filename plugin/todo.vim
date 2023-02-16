" todo.vim - Todo
" Author:    metiftikci
" Version:   1.0

if exists('g:loaded_todo')
  exit
endif

let g:loaded_todo = 1

function! s:isDoneTodoLine(line_text)
  return a:line_text =~ '^\s*- \[x\] '
endfunction

function! s:isNotDoneTodoLine(line_text)
  return a:line_text =~ '^\s*- \[ \] '
endfunction

function! s:hasCreatedTag(line_text)
  return a:line_text !~ ' @created(\d\d/\d\d)'
endfunction

function! s:hasUpdatedTag(line_text)
  return a:line_text !~ ' @updated(\d\d/\d\d)'
endfunction

function! s:generateCreatedTag(line_text)
  let today = strftime('%m/%d')
  return a:line_text . ' @created(' . today . ')'
endfunction

function! s:generateUpdatedTag(line_text)
  let today = strftime('%m/%d')
  return a:line_text . ' @updated(' . today . ')'
endfunction

function! AddCreateTag()
  let line_num = line('.')
  let line_text = getline(line_num)
  if s:isDoneTodoLine(line_text) || s:isNotDoneTodoLine(line_text)
    if s:hasCreatedTag(line_text)
      let created_text = s:generateCreatedTag(line_text)
      call setline(line_num, created_text)
    endif
  endif
endfunction

function! AddRemoveUpdateTag()
  let line_num = line('.')
  let line_text = getline(line_num)
  if s:isDoneTodoLine(line_text)
    if s:hasUpdatedTag(line_text)
      let updated_text = s:generateUpdatedTag(line_text)
      call setline(line_num, updated_text)
    endif
  elseif s:isNotDoneTodoLine(line_text)
    let updated_text = substitute(line_text, '\s\?@updated(\d\d/\d\d)', '', 'g')
    call setline(line_num, updated_text)
  endif
endfunction

augroup TODO
  autocmd!
  autocmd TextChanged,TextChangedI TODO.md call AddCreateTag()
  autocmd TextChanged,TextChangedI TODO.md call AddRemoveUpdateTag()
augroup end
