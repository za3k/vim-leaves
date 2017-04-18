if exists("g:loaded_research")
  finish
endif
let g:loaded_research = '0.1'

autocmd BufEnter *.leaves call LeafSetUpUi()
autocmd BufEnter *.index.leaves call LeafSetUpIndexUi()

function LeafSetUpLetter()
  "Would be 78 without hole punch
  let g:leaf_maxcols=74
  let g:leaf_maxrows=64
endfunction

function LeafSetUp3x5()
  let g:leaf_maxcols=47
  let g:leaf_maxrows=17
endfunction

if !exists("g:leaves_separator")
  let g:leaf_separator="==="
endif
if !exists("g:leaf_size")
  let g:leaf_size="letter"
endif
if !exists("g:leaf_maxrows") || !exists("g:leaf_maxcols")
  if g:leaf_size=="letter"
    call LeafSetUpLetter()
  endif
  if g:leaf_size=="3x5"
    call LeafSetUp3x5()
  endif
endif

function LeafFoldLevel(lnum)
    let thisline = getline(a:lnum)
    let nextline = getline(a:lnum+1)
    if thisline != g:leaf_separator && nextline == g:leaf_separator
        return '<1'
    else
        return 1
    endif
endfunction

function LeafFoldText()
    let firstlinenum = v:foldstart==1 ? v:foldstart : v:foldstart+1
    let firstline = getline(firstlinenum)
    let title = substitute(substitute(firstline, '^\s*', '', ''), '\s*$', '', '')
    let foldsize = (v:foldend - firstlinenum)
    let linecount = '['.foldsize.' line'.(foldsize>1?'s':'').']'
    return title.' '.linecount
endfunction

function LeafSetUpFolds()
    set foldexpr=LeafFoldLevel(v:lnum)
    set foldtext=LeafFoldText()
    set foldmethod=expr
endfunction

function LeafSetUpHighlight()
    let w:m1=matchadd('ErrorMsg', '\%>'.g:leaf_maxcols.'v.\+', -1)
    let foldstart='\%(^\|'.g:leaf_separator.'\n\)'
    let normalline='\%(\%('.g:leaf_separator.'\)\@!.*\n\)'
    let w:m2=matchadd('ErrorMsg', foldstart . normalline . '\{'.g:leaf_maxrows.'\}\zs' . normalline . '\+\ze', -1)
    "let w:m2=matchadd('ErrorMsg', '\%(^\|===\n\)\%(.*\n\)\{5}\zs\%(.*\n\)\+\ze', -1)
endfunction

function LeafRemoveHighlight()
    matchdelete(w:m1)
    matchdelete(w:m2)
endfunction

function LeafSetUpUi()
    call LeafSetUpFolds()
    call LeafSetUpHighlight()
    set foldlevel=1
    set foldcolumn=1
    syn sync fromstart
endfunction

function LeafSetUpIndexUi()
    call LeafSetUp3x5()
    call LeafSetUpUi()
endfunction

