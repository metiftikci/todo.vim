" todo.vim - Todo
" Author:    metiftikci
" Version:   1.1

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

function! s:hasDoneTag(line_text)
  return a:line_text !~ ' @done(\d\d/\d\d)'
endfunction

function! s:generateCreatedTag(line_text)
  let today = strftime('%m/%d')
  return a:line_text . ' @created(' . today . ')'
endfunction

function! s:generateDoneTag(line_text)
  let today = strftime('%m/%d')
  return a:line_text . ' @done(' . today . ')'
endfunction

function! s:isEdited()
  let undotree = undotree()
  let tipOfUndoTree = undotree.seq_last == undotree.seq_cur
  return &modifiable && &modified && tipOfUndoTree
endfunction

function! AddCreateTag()
  if !s:isEdited()
    return
  endif

  let line_num = line('.')
  let line_text = getline(line_num)
  if s:isDoneTodoLine(line_text) || s:isNotDoneTodoLine(line_text)
    if s:hasCreatedTag(line_text)
      let created_text = s:generateCreatedTag(line_text)
      call setline(line_num, created_text)
    endif
  endif
endfunction

function! AddRemoveDoneTag()
  if !s:isEdited()
    return
  endif

  let line_num = line('.')
  let line_text = getline(line_num)
  if s:isDoneTodoLine(line_text)
    if s:hasDoneTag(line_text)
      let done_text = s:generateDoneTag(line_text)
      call setline(line_num, done_text)
    endif
  elseif s:isNotDoneTodoLine(line_text)
    let done_text = substitute(line_text, '\s\?@done(\d\d/\d\d)', '', 'g')
    call setline(line_num, done_text)
  endif
endfunction

augroup TODO
  autocmd!
  autocmd TextChanged,TextChangedI TODO.md call AddCreateTag()
  autocmd TextChanged,TextChangedI TODO.md call AddRemoveDoneTag()
augroup end
