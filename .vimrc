:set hlsearch
:set sw=2
:set ts=2
:set autoindent
:set expandtab
autocmd BufReadPost COMMIT_EDITMSG
  \ exe "normal! gg"
