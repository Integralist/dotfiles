# dotfiles

### Configuration

- Keyboard keypress speed (and smart quotes off) via System Preferences
- Install Google Chrome, login and sync
- AppStore: Slack and Twitter
- MacDown (http://macdown.uranusjr.com/)
- Terminal: 
  - Zsh shell (`chsh -s /bin/zsh`)
  - Xcode (`xcode-select --install`)

### GitHub

- Setup ssh keys for github use, `cd ~/.ssh`, `ssh-keygen -t rsa -b 4096 -C "mark.mcdx@gmail.com"` and saved to `github_rsa`
- Start the ssh-agent `eval "$(ssh-agent -s)"`
- Add the ssh key to the agent `ssh-add ~/.ssh/github_rsa` (use `-K` flag for adding to Mac OSX Keychain for persistence)
- `pbcopy < ~/.ssh/github_rsa.pub` and paste into GitHub gui.
- Then `ssh -T git@github.com` to test the set-up is working
- `git config --global user.email "mark.mcdx@gmail.com"`
- `git config --global user.name "Integralist"`

### Software

- Setup "Box Sync" and "Dropbox"
  - `mkdir -p ~/.pki/bbc` then copy in certificates
  - `mkdir -p ~/Projects/Shell` and download [Antigen](http://antigen.sharats.me/) `antigen.zsh`
- Homebrew
  - `brew tap neovim/neovim && brew install --HEAD neovim` 
  - `brew install git rbenv ruby-build irssi leiningen reattach-to-user-namespace siege terminal-notifier the_silver_searcher tmux tree gpg watch go boot2docker`
- Java JDK, [Vagrant](https://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- Clone dotfiles repo and extract required files (including `.gitconfig`)
- Neovim
  - `vim +PluginInstall +qall`
- Terminal theme
