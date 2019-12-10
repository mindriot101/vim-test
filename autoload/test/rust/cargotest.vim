if !exists('g:test#rust#cargotest#file_pattern')
  let g:test#rust#cargotest#file_pattern = '\v\.rs$'
endif

function! test#rust#cargotest#test_file(file) abort
  return a:file =~# g:test#rust#cargotest#file_pattern
endfunction

function! test#rust#cargotest#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return [name, '--', '--exact']
    else
      return []
    endif
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
  let name = s:cargo_nearest_test_in_lines(a:position['file'], a:position['line'], 1, g:test#rust#patterns)
  return name['namespace'][0] . '::' . name['test'][0]
endfunction

function! s:cargo_nearest_test_in_lines(filename, from_line, to_line, patterns) abort
  let test         = []
  let namespace    = []
  let last_indent  = -1
  let current_line = a:from_line + 1
  let test_line    = -1
  let last_line    = ""

  let is_reverse = '$' == a:from_line ? 1 : a:from_line > a:to_line
  let lines = is_reverse
    \ ? reverse(getbufline(a:filename, a:to_line, a:from_line))
    \ : getbufline(a:filename, a:from_line, a:to_line)

  for line in lines
    let current_line    = current_line + (is_reverse ? -1 : 1)
    let test_match      = s:find_match(line . last_line, a:patterns['test'])
    let namespace_match = s:find_match(line . last_line, a:patterns['namespace'])

    let indent = len(matchstr(line, '^\s*'))
    if !empty(test_match) && last_indent == -1
      call add(test, filter(test_match[1:], '!empty(v:val)')[0])
      let last_indent = indent
      let test_line   = current_line
    elseif !empty(namespace_match) && (indent < last_indent || last_indent == -1)
      call add(namespace, filter(namespace_match[1:], '!empty(v:val)')[0])
      let last_indent = indent
    endif

    let last_line = line
  endfor

  return {'test': test, 'test_line': test_line, 'namespace': reverse(namespace)}
endfunction

function! s:find_match(line, patterns) abort
  let matches = map(copy(a:patterns), 'matchlist(a:line, v:val)')
  return get(filter(matches, '!empty(v:val)'), 0, [])
endfunction
