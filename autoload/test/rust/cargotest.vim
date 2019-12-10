if !exists('g:test#rust#cargotest#file_pattern')
  let g:test#rust#cargotest#file_pattern = '\v\.rs$'
endif

function! test#rust#cargotest#test_file(file) abort
  return a:file =~# g:test#rust#cargotest#file_pattern
endfunction

function! test#rust#cargotest#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    return [name]
  endif
  return []
endfunction

function! test#rust#cargotest#build_args(args) abort
  return a:args
endfunction

function! test#rust#cargotest#executable() abort
  return 'cargo test'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#rust#patterns)
  echo name
  messages
endfunction
