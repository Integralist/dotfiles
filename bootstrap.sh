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

# Setup File Search AutoComplete
git clone https://github.com/pindexis/qfc $HOME/.qfc
#printf '\n# Setup File Search AutoComplete\n[[ -s "$HOME/.qfc/bin/qfc.sh" ]] && source "$HOME/.qfc/bin/qfc.sh"' >> ~/.bashrc

# Install NeoVim
brew tap neovim/neovim && brew install --HEAD neovim

# Configure NeoVim/Vim
mkdir -p ~/.vim/{autoload,bundle,colors}
curl -LSso ~/.vim/colors/integralist.vim https://raw.githubusercontent.com/Integralist/dotfiles/master/.vim/colors/integralist.vim
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
curl -LSso ~/.vim/plugins https://raw.githubusercontent.com/Integralist/dotfiles/master/voom/plugins
curl -LSso /usr/local/bin/voom https://raw.githubusercontent.com/airblade/voom/master/voom
chmod 744 /usr/local/bin/voom
alias voom='VIM_DIR=~/.vim voom'
curl -LSso ~/.vimrc https://raw.githubusercontent.com/Integralist/dotfiles/master/.vimrc
# mkdir -p .config/nvim
ln -s ~/.vim ~/.config/nvim
ln -s ~/.vimrc ~/.config/nvim/init.vim
voom

# Ensure NeoVim is configured with spell checking options
nvim -E -s <<EOF
:set spell
:quit
EOF

# Install Curl with OpenSSL and HTTP2
brew install curl --with-openssl --with-nghttp2 && brew link curl --force

# Install other brew packages
# e.g. coreutils gives us 'shred' command (well, it's actually gnu'ed so it's really: gshred)
packages=(\
  ag\
  argon/mas/mas\
  bash-completion\
  bundler-completion\
  coreutils\
  docker-compose-completion\
  docker-machine\
  docker\
  fzf \
  gem-completion\
  gist\
  git\
  go\
  googler\
  gpg\
  gpg-agent\
  httpstat\
  imagemagick\
  irssi\
  keybase \
  leiningen\
  mutt\
  netcat\
  ngrok\
  node\
  pass\
  pstree\
  pyenv\
  rbenv\
  reattach-to-user-namespace\
  ruby-build\
  shellcheck\
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
  if [[ "$package" == "wireshark" ]]; then
    brew install $package --with-qt5 # brew cat wireshark (shows options)
  else
    brew install $package
  fi
done

# Configure Git
curl -LSso ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

# Configure Googler
curl -LSso ~/googler-completion.bash https://raw.githubusercontent.com/jarun/googler/master/auto-completion/bash/googler-completion.bash

# Configure Mutt
# You need a Google app password:
# https://security.google.com/settings/security/apppasswords
mkdir -p ~/.mutt/cache/{headers,bodies}
touch ~/.mutt/certificates

cat > ~/.mutt/passwords <<EOF
set imap_pass="<google-app-password>"
set smtp_pass="<google-app-password>"
EOF

printf "\n\nYou need to change the password in ~/.mutt/passwords:\n\n\tgpg -r mark.mcdx@gmail.com -e ~/.mutt/passwords &&\n\tgshred ~/.mutt/passwords &&\n\trm ~/.mutt/passwords\n\nOnce done the confirm you're ready to continue: (y)es or (n)o\n\n"
read cont
if [ $cont == "y" ] || [ $cont == "Y" ] ; then
  echo "Cool, let's keep going..."
else
  echo "OK let's stop here and you can continue on manually"
  exit
fi

cat > ~/.mutt/passwords-buzzfeed <<EOF
set imap_pass="<google-app-password>"
set smtp_pass="<google-app-password>"
EOF

printf "\n\nYou need to change the password in ~/.mutt/passwords-buzzfeed:\n\n\tgpg -r mark.mcdonnell@buzzfeed.com -e ~/.mutt/passwords-buzzfeed &&\n\tgshred ~/.mutt/passwords-buzzfeed &&\n\trm ~/.mutt/passwords-buzzfeed\n\nOnce done the confirm you're ready to continue: (y)es or (n)o\n\n"
read cont
if [ $cont == "y" ] || [ $cont == "Y" ] ; then
  echo "Cool, let's keep going..."
else
  echo "OK let's stop here and you can continue on manually"
  exit
fi

curl -LSso ~/.muttrc https://raw.githubusercontent.com/Integralist/dotfiles/master/.muttrc

curl -LSso ~/.gitignore-global https://raw.githubusercontent.com/Integralist/dotfiles/master/.gitignore-global

curl -LSso ~/diff-highlight https://raw.githubusercontent.com/git/git/master/contrib/diff-highlight/diff-highlight
chmod +x ~/diff-highlight

curl -LSso ~/.gitconfig https://raw.githubusercontent.com/Integralist/dotfiles/master/.gitconfig

# git config --global --add alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
# git config --global --add alias.st status
# git config --global --add alias.unstage "reset HEAD --"
# git config --global --add apply.whitespace nowarn
# git config --global --add color.branch.current "yellow reverse"
# git config --global --add color.branch.local yellow
# git config --global --add color.branch.remote green
# git config --global --add color.commit red
# git config --global --add color.diff-highlight.newhighlight "green bold 22"
# git config --global --add color.diff-highlight.newnormal "green bold"
# git config --global --add color.diff-highlight.oldhighlight "red bold 52"
# git config --global --add color.diff-highlight.oldnormal "red bold"
# git config --global --add color.diff.frag magenta
# git config --global --add color.diff.meta yellow
# git config --global --add color.diff.new green
# git config --global --add color.diff.old red
# git config --global --add color.status.added red
# git config --global --add color.status.changed blue
# git config --global --add color.status.untracked magenta
# git config --global --add color.ui true
# git config --global --add core.editor nvim
# git config --global --add core.excludesfile ~/.gitignore-global
# git config --global --add core.ignorecase false
# git config --global --add merge.conflictstyle diff3
# git config --global --add merge.tool vimdiff
# git config --global --add mergetool.prompt true
# git config --global --add push.default upstream
# git config --global --add url.git@github.com:.insteadof https://github.com/
# git config --global --add user.email mark.mcdx@gmail.com
# git config --global --add user.name Integralist
# git config --global --add pager.log '~/diff-highlight | less'
# git config --global --add pager.show '~/diff-highlight | less'
# git config --global --add pager.diff '~/diff-highlight | less'
# git config --global --add interactive.diffFilter ~/diff-highlight
# git config --global --add diff.compactionHeuristic true

# GitHub setup
mkdir ~/.ssh
curl -LSso ~/.ssh/config https://raw.githubusercontent.com/Integralist/dotfiles/master/.ssh/config
cd ~/.ssh && sshkey # sshkey is a .bashrc alias
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

# Install some apps via Brew Cask
brew cask
brew cask install --appdir="/Applications" caffeine
brew cask install --appdir="/Applications" dropbox
brew cask install --appdir="/Applications" google-chrome
brew cask install --appdir="/Applications" google-drive
brew cask install --appdir="/Applications" java
brew cask install --appdir="/Applications" macdown
brew cask install --appdir="/Applications" spotify
brew cask install --appdir="/Applications" vlc
brew cask install --appdir="/Applications" licecap
brew cask install --appdir="/Applications" dripcap # packet analyser (like Wireshark)

# Configure Golang (~/.bashrc already sets GOPATH)
mkdir -p ~/code/go
go get golang.org/x/tools/cmd/goimports

# Miscellaneous
curl -LSso ~/.gitconfig https://raw.githubusercontent.com/Integralist/dotfiles/master/.gitconfig
curl -LSso ~/.gitignore-global https://raw.githubusercontent.com/Integralist/dotfiles/master/.gitignore-global
curl -LSso ~/.rspec https://raw.githubusercontent.com/Integralist/dotfiles/master/.rspec
curl -LSso ~/.rubocop.yml https://raw.githubusercontent.com/Integralist/dotfiles/master/.rubocop.yml
curl -LSso ~/.signature https://raw.githubusercontent.com/Integralist/dotfiles/master/.signature
curl -LSso ~/.tmux.conf https://raw.githubusercontent.com/Integralist/dotfiles/master/.tmux.conf
curl -LSso ~/.urlview https://raw.githubusercontent.com/Integralist/dotfiles/master/.urlview # use <Ctrl-b> within mutt to activate
npm install -g tldr # https://github.com/tldr-pages/tldr

# Needed to add your GPG keys to the agent
# http://linux.die.net/man/1/gpg-agent 
eval $(gpg-agent --daemon)

# Install applications from Mac App Store
#mas install 411246225 # Caffeine
#mas install 458034879 # Dash
#mas install 803453959 # Slack
#mas install 409789998 # Twitter
printf "\n\nDon't forget to install Caffeine, Dash, Slack, Twitter from App Store\n\n"

# Install Python Stuff
mkdir -p ~/code/{python,python2}

cd ~/code/python2
pyenv install 2.7.6
pyenv local 2.7.6
pip install --upgrade neovim
pip install goobook
goobook authenticate

cat > ~/.goobookrc <<EOF
[DEFAULT]
email: mark.mcdonnell@buzzfeed.com
oauth_db_filename: ~/.goobook_auth.json
EOF

cd ~/code/python
pyenv install 3.5.1
pyenv local 3.5.1
pip install --upgrade neovim
pip install pylint flake8 flake8-quotes pep8-naming

keybase login
# keybase prove twitter integralist
# keybase prove github integralist
