-- We remove the Vim builtin colorschemes so they don't show in Telescope.
vim.cmd([[
  silent !rm $VIMRUNTIME/colors/*.vim &> /dev/null
  set background=dark
  let g:gruvbox_material_background = "hard"
  let g:gruvbox_material_foreground = "original"
  colorscheme gruvbox-material
  highlight link GitSignsChange GruvboxYellowSign
]])

-- NOTE: If you want to quickly change the background colour of a theme, and
-- also the default text colour (e.g. the Ex command line color) then the
-- following highlight group will affect that.
--
-- :hi Normal guifg=#e0def4 guibg=#232136
--
-- :lua TweakTheme("white", "pink")
-- :lua TweakTheme("#ffffff", "#000000")
function TweakTheme(fg, bg)
  vim.cmd("hi Normal guifg=" .. fg .. " guibg=" .. bg)
end
