-- We remove the Vim builtin colorschemes so they don't show in Telescope.
vim.cmd([[
  silent !rm $VIMRUNTIME/colors/*.vim &> /dev/null
  set background=dark
  colorscheme gruvbox
  highlight link GitSignsChange GruvboxYellowSign
]])
