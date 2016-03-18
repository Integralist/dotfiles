# dotfiles

### Configuration

- Keyboard keypress speed (and smart quotes off) via System Preferences
- Show Battery Percentage and Date/Time via System Preferences
- Install Google Chrome, login and sync
- AppStore: Slack, Twitter and Caffeine
- MacDown (http://macdown.uranusjr.com/)
- Terminal: 
  - Bash shell (`brew install bash; echo /usr/local/bin/bash | sudo tee -a /etc/shells; chsh -s /usr/local/bin/bash`)
  - Zsh shell (`chsh -s /bin/zsh`)
  - Xcode (`xcode-select --install`)

### GitHub

- Setup ssh keys for github use:  
`cd ~/.ssh`, `ssh-keygen -t rsa -b 4096 -C "mark.mcdx@gmail.com"` and saved to `github_rsa`
- Start the ssh-agent:  
`eval "$(ssh-agent -s)"`
- Add the ssh key to the agent:  
`ssh-add ~/.ssh/github_rsa`  
(use `-K` flag for adding to Mac OSX Keychain for persistence)
- `pbcopy < ~/.ssh/github_rsa.pub` and paste into GitHub gui.
- Then `ssh -T git@github.com` to test the set-up is working
- `git config --global user.email "mark.mcdx@gmail.com"`
- `git config --global user.name "Integralist"`

> Note: you can also try out git-diff-fancy  
> `npm install -g diff-so-fancy`  
> One time: `git diff | diff-highlight | diff-so-fancy`  
> Permanent: `git config --global core.pager "diff-so-fancy | less --tabs=1,5 -R"`

### Software

- Setup "Box Sync" and "Dropbox"
  - `mkdir -p ~/.pki/bbc` then copy in certificates
  - `mkdir -p ~/Projects/Shell` and download [`antigen.zsh`](https://github.com/zsh-users/antigen/blob/master/antigen.zsh)
- Java JDK, [Vagrant](https://www.vagrantup.com/downloads.html), [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Docker Machine](https://www.docker.com/toolbox)
- Homebrew
  - `brew update`
  - `brew tap neovim/neovim && brew install --HEAD neovim` 
  - `brew install git rbenv ruby-build irssi leiningen reattach-to-user-namespace siege terminal-notifier the_silver_searcher tmux tree gpg watch go wrk ngrok docker docker-machine`
- Clone this dotfiles repo and extract required files (e.g. `cd ~/Projects/Shell/dotfiles/ && mv .*~.git ~/`)
- Neovim
  - Delete all folders inside `~/.vim/bundle`
  - `git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim`
  - `vim +PluginInstall +qall`
- Terminal theme
- Golang
  - `go get golang.org/x/tools/cmd/goimports`
  - `mkdir -p ~/Projects/golang`
  - `go get github.com/svent/sift` (`sift --files 'c*\.go' -n package`)
- Run `:set spell` after installing NeoVim (otherwise you'll see an error in future about it not being set)
