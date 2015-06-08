# dotfiles

## Moving to Linux

So although this repo contains my dotfiles specifically set-up for Linux it would be worth me documenting somewhere (here) the overall Linux set-up for a fresh laptop install (and specifically a Macintosh laptop which has Linux installed onto it - not via a VM but actually running on the Mac hardware)...

## Fixing issues

### Could not apply stored configuration to monitors

Look in home directory for `monitors.xml` and rename it to anything else (then restart)

### Wireless icon in menu bar is missing

- `sudo apt-get install --reinstall libappindicator3-1`
- `sudo apt-get install --reinstall libappindicator1`
- Restart

### Ubuntu can't detect wifi

- Download and install this driver: https://launchpad.net/ubuntu/vivid/amd64/bcmwl-kernel-source/6.30.223.248+bdcom-0ubuntu2
- `sudo apt-get install dkms libc6-dev linux-libc-dev`
- Detach ethernet cable and restart

## Software

- Installed Chromium browser from "Ubuntu Software Centre"
- Messed around with Chrome's accessibility to get the right sort of zoom for my poor eyes (did the same for Screen Resolution settings in System Preferences)
- Keyboard incompatibilities:
  - Repeated key: reduce the delay to ~2 steps from zero and increase the speed to 50%
  - Switch to "UK Macintosh" keyboard layout
  - Hash character is RightAlt+3 (as apposed to LeftAlt+3 like Mac OSX)
  - The `fn` key acts like start and end of line/file
  - The `Ctrl` key is effectively the `Cmd` key (except for the terminal where you need to prefix with `Shift`)
  - Hold down `Cmd` key to see HUD of keyboard shortcuts
- `sudo apt-get install zsh` and `sudo chsh -s $(which zsh)` and then restart
- `sudo apt-get install git`
- `sudo apt-get install curl`
- `sudo apt-get install default-jre` and `java -version`

### Neovim

```bash
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim
sudo apt-get install python-dev python-pip python3-dev python3-pip
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --config vi
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --config vim
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
sudo update-alternatives --config editor 
```

### Configure Neovim

- See the `linux` branch of this repo
- `echo "source ~/.vimrc" > ~/.nvimrc`
- `git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim`
- Copy developer certificates over to `~/.pki/bbc`
- `apt-get install silversearcher-ag`
- `cp ~/Projects/dotfiles/.agignore ~/Projects/dotfiles/.gitconfig ~/`

### tmux

```bash
sudo add-apt-repository ppa:pi-rho/dev
sudo apt-get update
sudo apt-get install tmux
```

### Shell tools

- `mkdir -p ~/Projects/Shell` and download [Antigen](http://antigen.sharats.me/) `antigen.zsh`
- `sudo apt-get install xdotool` for automatically zooming every time the terminal starts (& trigger full screen)

### GitHub

- Setup ssh keys for github use, `cd ~/.ssh`, `ssh-keygen -t rsa -b 4096 -C "mark.mcdx@gmail.com"` and saved to `github_rsa`
- Start the ssh-agent `eval "$(ssh-agent -s)"`
- Add the ssh key to the agent `ssh-add ~/.ssh/github_rsa`
- `sudo apt-get install xclip` and `xclip -sel clip < ~/.ssh/github_rsa.pub` and paste into GitHub gui.
- Then `ssh -T git@github.com` to test the set-up is working
- `git config --global user.email "mark.mcdx@gmail.com"`
- `git config --global user.name "Mark McDonnell"`

### Docker

- `wget -qO- https://get.docker.com/ | sh`
- `sudo usermod -aG docker integralist`

### Docker Compose

- `sudo curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` -o docker-compose`
- `sudo mv docker-compose /usr/local/bin/`
- `sudo chmod +x /usr/local/bin/docker-compose`
- `docker-compose --version`
