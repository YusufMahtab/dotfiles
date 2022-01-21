call plug#begin('~/.config/nvim/plugged')

Plug 'mhartington/oceanic-next'
Plug 'ThePrimeagen/vim-be-good'

call plug#end()

if (has("termguicolors"))
 set termguicolors
endif

syntax enable
colorscheme OceanicNext

let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0

set number
