-- We remove the Vim builtin colorschemes so they don't show in Telescope.
vim.cmd([[
  function! FixGruvboxForNoice() abort
    if g:colors_name == "gruvbox"
      highlight NoiceCmdlinePopupBorderCmdline guifg=#83a598 guibg=NONE
      highlight NoiceCmdlinePopupBorderFilter guifg=#83a598 guibg=NONE
      highlight NoiceCmdlinePopupBorderHelp guifg=#83a598 guibg=NONE
      highlight NoiceCmdlinePopupBorderInput guifg=#83a598 guibg=NONE
      highlight NoiceCmdlinePopupBorderLua guifg=#83a598 guibg=NONE
      highlight NoiceCmdlinePopupBorderSearch guifg=#fabd2f guibg=NONE

      highlight NoiceCmdlineIconCmdline guifg=#83a598 guibg=NONE
      highlight NoiceCmdlineIconFilter guifg=#83a598 guibg=NONE
      highlight NoiceCmdlineIconHelp guifg=#83a598 guibg=NONE
      highlight NoiceCmdlineIconInput guifg=#83a598 guibg=NONE
      highlight NoiceCmdlineIconLua guifg=#83a598 guibg=NONE
      highlight NoiceCmdlineIconSearch guifg=#fabd2f guibg=NONE
    endif
  endfunction

  augroup ApplyFixGruvboxForNoice
    autocmd!
    autocmd ColorScheme * call FixGruvboxForNoice()
  augroup END

  silent !rm $VIMRUNTIME/colors/*.vim &> /dev/null
  set background=dark
  colorscheme gruvbox
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
