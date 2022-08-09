-- We remove the Vim builtin colorschemes so they don't show in Telescope.
vim.cmd([[
  silent !rm $VIMRUNTIME/colors/*.vim &> /dev/null
  set background=dark
  let g:gruvbox_material_background = "hard"
  let g:gruvbox_material_foreground = "original"
  colorscheme gruvbox-material
  highlight link GitSignsChange GruvboxYellowSign
]])
