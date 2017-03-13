# dotfiles

If you want to just get going then execute:

```bash
curl -LSso ~/bootstrap.sh https://raw.githubusercontent.com/Integralist/dotfiles/master/bootstrap.sh
/bin/bash bootstrap.sh
```

> Although I would instead recommend manually executing each line of `bootstrap.sh` manually as it allows you to deal with runtime errors (e.g. slow connections or missing configuration etc) a lot more easily and also means you can bypass things you don't need

## Setup

So here's some key software that I like to setup manually...

### GPG

One of the most important things (for me) is to get my GPG keys setup. Once you have GPG installed, pull your private key from wherever you have it stored (e.g. external USB stick), then execute:

```sh
gpg --import <private-key>
gpg --export <key-id> # public key by default
```

I have a private repo with a git repository host, which stores my existing GPG files:

```sh
pass init "<key-id>" # create new pass store (~/.password-store)
                     # ln -s ~/sync-location/.password-store/ ~/.password-store
pass git init
pass git remote add origin <git-host>
pass git pull
```

Don't forget you can sign your git commits:

```sh
git config --global user.signingkey <key-id>
```

If `gpg --list-keys` shows `4096R/12345678`, then your `<key-id>` would be `12345678`

If you have two separate git users, then don't use the `--global` flag.  
Instead, run the command from the root of each git repo.

### Software

- Install Google Chrome (login and sync)
- AppStore: Slack, Twitter, Dash and Caffeine
- GitHub: [Lepton (a GitHub Gist Client)](https://github.com/hackjutsu/Lepton)
- [Monitor Brightness App](http://www.splasm.com/brightnesscontrol/index.html)

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

### Cloud

Don't forget to download the relevant software for your cloud provider of choice

e.g. Google Drive, Dropbox, Box etc

### Virtualisation

- [Vagrant](https://www.vagrantup.com/downloads.html)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

### Docker

Install [`ctop`](https://github.com/bcicen/ctop) which provides a `top` like interface for container metrics

If you're unable to utilise the new Docker for Mac (hardware requirements might prevent you), then you'll need to manually install Vagrant and Virtual Box, along with Docker Machine and Docker Compose:

- `brew cask install virtualbox`
- `brew cask install vagrant`
- `brew install docker-machine`
- `brew install docker-compose`
- `docker-machine create --driver virtualbox local`
- `echo eval "$(docker-machine env local)" >> ~/.bashrc`

### Programming

- [Python](https://www.python.org/)
- [Golang](https://golang.org/)
  - `go get golang.org/x/tools/cmd/goimports`
- `npm install -g t-get`
