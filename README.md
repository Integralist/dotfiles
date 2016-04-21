# dotfiles

If you want to just get going then execute:

```bash
curl -LSso ~/bootstrap.sh https://raw.githubusercontent.com/Integralist/dotfiles/master/bootstrap.sh
/bin/bash bootstrap.sh
```

Otherwise here's a breakdown of what we need...

### Software

- Install Google Chrome (login and sync)
- AppStore: Slack, Twitter and Caffeine
- MacDown (http://macdown.uranusjr.com/)

### GitHub

- Setup ssh keys for github use:  
  ```
  cd ~/.ssh && sshkey # github_rsa
  ```
- Start the ssh-agent:  
  ```
  eval "$(ssh-agent -s)"
  ```
- Add the ssh key to the agent:  
  ```
  ssh-add -K ~/.ssh/github_rsa # -K for Mac OS X keychain persistence
  ```
- Get copy of public key:  
  ```
  pbcopy < ~/.ssh/github_rsa.pub # paste into GitHub GUI
  ```
- Test setup:  
  ```
  ssh -T git@github.com
  ```

> Note: you can also try out git-diff-fancy  
> `npm install -g diff-so-fancy`  
> One time: `git diff | diff-highlight | diff-so-fancy`  
> Permanent: `git config --global core.pager "diff-so-fancy | less --tabs=1,5 -R"`

### GPG

- Create key `gpg --gen-key` (or import it if you already have one: `gpg --import`)
- Add it to GitHub config `git config --global user.signingkey <hash>` (e.g. `4096R/12345678` then hash would be `12345678`)
- Now when tagging git commits you'll use `-s` instead of `-a`

> Note: if you have two separate git users  
> then don't use `--global` flag and instead  
> run command from root of each git repo

### Miscellaneous

- Install "Box Sync" and "Dropbox"
- Then copy in your certificates:  
  ```
  mkdir -p ~/.pki/bbc
  ```
- Java JDK, [Vagrant](https://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- Golang
  - `go get golang.org/x/tools/cmd/goimports`
  - `mkdir -p ~/Projects/golang`
  - `go get github.com/svent/sift` (`sift --files 'c*\.go' -n package`)
- Python
  - `sudo easy_install pip`
  - `sudo pip install flake8` 
  - `sudo pip install pylint`

### Docker

If you're unable to utilise the new Docker for Mac beta, then you'll need to manually install Vagrant and Virtual Box, along with Docker Machine and Docker Compose:

- `brew cask install virtualbox`
- `brew cask install vagrant`
- `brew install docker-machine`
- `brew install docker-compose`
- `docker-machine create --driver virtualbox local`
- `echo eval "$(docker-machine env local)" >> ~/.bashrc`
