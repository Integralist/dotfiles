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

# Configure Terminal
curl -LSso ~/Integralist.terminal https://raw.githubusercontent.com/Integralist/mac-os-terminal-theme-integralist/master/Integralist.terminal
open ~/Integralist.terminal
defaults write com.apple.Terminal "Default Window Settings" Integralist
defaults write com.apple.Terminal "Startup Window Settings" Integralist
rm ~/Integralist.terminal

printf "\n\nDon't forget to change the terminal font to menlo (and double check theme is set to default)"
printf "\n\nOnce done the confirm you're ready to continue: (y)es or (n)o\n\n"
read cont
if [ $cont == "y" ] || [ $cont == "Y" ] ; then
  echo "Cool, let's keep going..."
else
  echo "OK let's stop here and you can continue on manually"
  exit
fi

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
curl -LSso ~/.bash-preexec.sh https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh
curl -LSso ~/.bashrc https://raw.githubusercontent.com/Integralist/dotfiles/master/.bashrc
curl -LSso ~/.bash_profile https://raw.githubusercontent.com/Integralist/dotfiles/master/.bash_profile
curl -LSso ~/.inputrc https://raw.githubusercontent.com/Integralist/dotfiles/master/.inputrc

# Install Vim
brew install vim --without-python --with-python3

# Configure Vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -LSso ~/.vimrc https://raw.githubusercontent.com/Integralist/dotfiles/master/.vimrc

# Ensure Vim is configured with spell checking options
vim -E -s <<EOF
:set spell
:quit
EOF

# Install Curl with OpenSSL and HTTP2
brew install curl --with-openssl --with-nghttp2 && brew link curl --force

# Install other brew packages
# 
# - coreutils gives us 'shred' command (well, it's actually gnu'ed so it's really: gshred)
# - exif is used by .gitattributes
# - go to switch version you can use `brew switch go x.x.x`
# - pyenv used by pipenv
# - ripgrep is used by FZF configuration (see below)
packages=(\
  ag\
  asciinema\
  bash-completion\
  bundler-completion\
  coreutils\
  docker\
  exif\
  fzf \
  git\
  gnupg2\
  go\
  gpg-agent\
  irssi\
  keybase \
  mas\
  ngrok\
  pass\
  pass-otp\
  pstree\
  pwgen\ 
  pyenv\ 
  reattach-to-user-namespace\
  ripgrep\
  shellcheck\
  siege\
  sift\
  speedtest-cli\
  the_silver_searcher\
  tmate\
  tmux\
  tree\
  watch\
  wget\
  wireshark\
)
for package in "${packages[@]}"
do
  if [[ "$package" == "wireshark" ]]; then
    brew install $package --with-qt5 # brew cat wireshark (shows options)
  else
    brew install $package
  fi
done

# Configure FZF
# Don't ignore hidden files (uses ripgrep instead of find command)
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob \!.git'

# Configure Git
curl -LSso ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
curl -LSso ~/.gitattributes https://raw.githubusercontent.com/Integralist/dotfiles/master/.gitattributes
curl -LSso ~/.gitignore-global https://raw.githubusercontent.com/Integralist/dotfiles/master/.gitignore-global
curl -LSso ~/.gitconfig https://raw.githubusercontent.com/Integralist/dotfiles/master/.gitconfig

curl -LSso ~/diff-highlight https://raw.githubusercontent.com/git/git/master/contrib/diff-highlight/diff-highlight
chmod +x ~/diff-highlight

# If you need to configure Git manually:
# git config --global --add <group>.<key> <value>
#
# e.g.
# git config --global --add user.name Integralist

# GitHub setup
mkdir ~/.ssh
curl -LSso ~/.ssh/config https://raw.githubusercontent.com/Integralist/dotfiles/master/.ssh/config
cd ~/.ssh && sshkey # sshkey is a .bashrc alias that generates an ssh key
                    # it'll require interaction via the terminal prompt
                    # so make sure you name the key `github_rsa`
                    # otherwise the following ssh-add will fail
eval "$(ssh-agent -s)"
ssh-add -K ~/.ssh/github_rsa
printf "\n\nDon't forget to \`pbcopy < ~/.ssh/github_rsa.pub\` and paste your public key into GitHub"
printf "\n\nOnce done the confirm you're ready to continue: (y)es or (n)o\n\n"
read cont
if [ $cont == "y" ] || [ $cont == "Y" ] ; then
  echo "Cool, let's keep going..."
else
  echo "OK let's stop here and you can continue on manually"
  exit
fi
ssh -T git@github.com

# Configure Golang (~/.bashrc already sets GOPATH)
mkdir -p ~/code/go
printf "\n\nDon't forget to run :GoInstallBinaries from within vim (once you have vim-go installed)"

# Miscellaneous
curl -LSso ~/.tmux.conf https://raw.githubusercontent.com/Integralist/dotfiles/master/.tmux.conf
curl -LSso ~/tmux.sh https://raw.githubusercontent.com/Integralist/dotfiles/master/tmux.sh

printf "\n\nIf you want things like tldr and dockly, then install Node using something like https://github.com/creationix/nvm"
# npm install -g tldr (https://github.com/tldr-pages/tldr)
# npm install -g dockly (https://github.com/lirantal/dockly)
# npm install -g carbon-now-cli (https://github.com/mixn/carbon-now-cli)

# Needed to add your GPG keys to the agent
# http://linux.die.net/man/1/gpg-agent 
eval $(gpg-agent --daemon)

# Install some apps via Brew Cask
# Note: not sure --appdir is necessary to set anymore?
brew cask
brew cask install --appdir="/Applications" alfred
brew cask install --appdir="/Applications" caffeine
brew cask install --appdir="/Applications" dripcap # packet analyser (like Wireshark)
brew cask install --appdir="/Applications" dropbox
brew cask install --appdir="/Applications" flux
brew cask install --appdir="/Applications" google-chrome
brew cask install --appdir="/Applications" google-drive
brew cask install --appdir="/Applications" java
brew cask install --appdir="/Applications" licecap
brew cask install --appdir="/Applications" macdown
brew cask install --appdir="/Applications" owasp-zap
brew cask install --appdir="/Applications" spotify
brew cask install --appdir="/Applications" vlc

# Install applications from Mac App Store
#mas install 411246225 # Caffeine
#mas install 458034879 # Dash
#mas install 803453959 # Slack
#mas install 409789998 # Twitter
printf "\n\nDon't forget to install Caffeine, Dash, Slack, Twitter from App Store (try `mas` command?)\n\n"

# Configure Python
mkdir -p ~/code/python/3.7
pip install pipenv
printf "\n\nSee this gist for usage example:\n\thttps://gist.github.com/Integralist/fd603239cacbb3d3d317950905b76096"
cd ~/code/python/3.7
pipenv --python 3.7
pipenv shell
pipenv install boto3 pytest structlog tornado
pipenv install --dev flake8 flake8-import-order mypy tox ipython

keybase login
# keybase prove twitter integralist
# keybase prove github integralist

printf "\nDon't forget to:\n\n\t%s\n" "ln -s ~/Google\ Drive/Keys/Pass/.password-store/ ~/.password-store"
printf "\nAlso, you'll want to install pass-otp (for 2FA)\n\n\thttps://github.com/tadfisher/pass-otp\n"
printf "\nAlso, you'll want to install Lepton (a GitHub Gist Client)\n\n\thttps://github.com/hackjutsu/Lepton\n"
printf "\nAlso, you'll want to install Windscribe (a VPN client with 15gb monthly data)\n\n\thttps://windscribe.com/\n"
