#!/bin/bash

# Enable a form of 'strict mode' for Bash
set -euo pipefail
IFS=$'\n\t'

# Enable hidden files in Finder (use toggle_hidden function from ~/.bashrc)
defaults write com.apple.finder AppleShowAllFiles YES

# Show all file extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Decrease delay between repeated keys
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 0
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Disable smart quotes and dashes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write com.apple.TextEdit SmartQuotes -bool false
defaults write com.apple.TextEdit SmartDashes -bool false

# Configure menu bar clock to something useful
defaults write com.apple.menuextra.clock "DateFormat" "EEE d MMM  HH:mm:ss"
defaults write com.apple.menuextra.clock "FlashDateSeparators" 0
defaults write com.apple.menuextra.clock "IsAnalog" 0

# Configure Mouse Seconday Button
defaults write com.apple.mouse "enableSecondaryClick" 1
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string "TwoButton"

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict General -bool true OpenWith -bool true Privileges -bool true Preview -bool false

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Setup Terminal preferences
curl -LSso ~/smyck.terminal https://raw.githubusercontent.com/Integralist/dotfiles/master/terminal-themes/Smyck.terminal
open ~/smyck.terminal
defaults write com.apple.Terminal "Default Window Settings" smyck
defaults write com.apple.Terminal "Startup Window Settings" smyck

# Install xcode
xcode-select --install

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update

# Install Bash
brew install bash
echo /usr/local/bin/bash | sudo tee -a /etc/shells
chsh -s /usr/local/bin/bash

# Configure Bash
curl -LSso ~/.bashrc https://raw.githubusercontent.com/Integralist/dotfiles/master/.bashrc

cat > ~/.bash_profile <<EOF
if [ -f $HOME/.bashrc ]; then
  source ~/.bashrc
  cd .
fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  source $(brew --prefix)/etc/bash_completion
fi
EOF

cat > ~/.inputrc <<EOF
TAB: menu-complete
"\e[Z": "\e-1\C-i"
EOF

# Install NeoVim
brew tap neovim/neovim && brew install --HEAD neovim

# Configure NeoVim/Vim
mkdir -p ~/.vim/{autoload,bundle}
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
curl -LSso ~/.vim/plugins https://raw.githubusercontent.com/Integralist/dotfiles/master/voom/plugins
curl -LSso /usr/local/bin/voom https://raw.githubusercontent.com/airblade/voom/master/voom
chmod 744 /usr/local/bin/voom
alias voom='VIM_DIR=~/.vim voom'
curl -LSso ~/.vimrc https://raw.githubusercontent.com/Integralist/dotfiles/master/.vimrc
ln -s ~/.vim ~/.config/nvim
ln -s ~/.vimrc ~/.config/nvim/init.vim
voom

nvim -E -s <<EOF
:set spell
:quit
EOF

# Install Curl with OpenSSL and HTTP2
brew install curl --with-openssl --with-nghttp2 && brew link curl --force

# Install other brew packages
packages=(\
  argon/mas/mas\
  bash-completion\
  bundler-completion\
  docker-compose-completion\
  docker-machine\
  docker\
  gem-completion\
  gist\
  git\
  go\
  gpg\
  irssi\
  leiningen\
  mutt\
  netcat\
  ngrok\
  node\
  python3\
  rbenv\
  reattach-to-user-namespace\
  ruby-build\
  siege\
  sift\
  speedtest-cli\
  terminal-notifier\
  the_silver_searcher\
  tmate\
  tmux\
  tree\
  urlview\
  watch\
  wget\
  wireshark\
)
for package in "${packages[@]}"
do
  brew install $package
done

# Install Python Syntax Checker
sudo easy_install pip
sudo pip install flake8
sudo pip install pylint

# Configure Git
curl -LSso ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

cat > ~/.gitignore-global <<EOF
# bundler
.gem
.bin
.ruby-version
failed_cukes.sh

# miscellaneous
*.DS_Store
.sass-cache
.grunt
tags
*.swp
logs
*.log
.vagrant*
EOF

git config --global --add alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
git config --global --add alias.st status
git config --global --add alias.unstage "reset HEAD --"
git config --global --add apply.whitespace nowarn
git config --global --add color.branch.current "yellow reverse"
git config --global --add color.branch.local yellow
git config --global --add color.branch.remote green
git config --global --add color.commit red
git config --global --add color.diff-highlight.newhighlight "green bold 22"
git config --global --add color.diff-highlight.newnormal "green bold"
git config --global --add color.diff-highlight.oldhighlight "red bold 52"
git config --global --add color.diff-highlight.oldnormal "red bold"
git config --global --add color.diff.frag magenta
git config --global --add color.diff.meta yellow
git config --global --add color.diff.new green
git config --global --add color.diff.old red
git config --global --add color.status.added red
git config --global --add color.status.changed blue
git config --global --add color.status.untracked magenta
git config --global --add color.ui true
git config --global --add core.editor nvim
git config --global --add core.excludesfile ~/.gitignore-global
git config --global --add core.ignorecase false
git config --global --add merge.conflictstyle diff3
git config --global --add merge.tool vimdiff
git config --global --add mergetool.prompt true
git config --global --add push.default upstream
git config --global --add url.git@github.com:.insteadof https://github.com/
git config --global --add user.email mark.mcdx@gmail.com
git config --global --add user.name Integralist

# GitHub setup
mkdir ~/.ssh
curl -LSso ~/.ssh/config https://raw.githubusercontent.com/Integralist/dotfiles/master/.ssh/config
cd ~/.ssh && sshkey # sshkey is .bashrc alias
eval "$(ssh-agent -s)"
printf "\n\nDon't forget to \`pbcopy < ~/.ssh/github_rsa.pub\` and paste your public key into GitHub"
printf "\n\nOnce done the confirm you're ready to continue: (y)es or (n)o\n\n"
read cont
if [ $cont == "y" ] || [ $cont == "Y" ] ; then
  echo "Cool, let's keep going..."
else
  echo "OK let's stop here and you can continue on manually"
fi
ssh -T git@github.com

# Install some apps via Brew Cask
brew cask
brew cask install box-sync
brew cask install caffeine
brew cask install dropbox
brew cask install google-chrome
brew cask install java
brew cask install macdown
brew cask install spotify
brew cask install vlc

# Configure Golang (~/.bashrc already sets GOPATH)
mkdir -p ~/Projects/golang
go get golang.org/x/tools/cmd/goimports

# Miscellaneous
echo COMMAND open %s > ~/.urlview # use <Ctrl-b> within mutt to activate
echo --color --format documentation --format=Nc > ~/.rspec
curl -LSso ~/.tmux.conf https://raw.githubusercontent.com/Integralist/dotfiles/master/.tmux.conf
rm ~/smyck.terminal

# Install applications from Mac App Store
#mas install 411246225 # Caffeine
#mas install 458034879 # Dash
#mas install 803453959 # Slack
#mas install 409789998 # Twitter
printf "\n\nDon't forget to install Caffeine, Dash, Slack, Twitter from App Store\n\n"
