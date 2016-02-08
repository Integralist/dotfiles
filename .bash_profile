if [ -f $HOME/.bashrc ]; then
  source ~/.bashrc
  cd .
fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  source $(brew --prefix)/etc/bash_completion
fi
