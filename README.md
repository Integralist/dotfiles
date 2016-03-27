# dotfiles

```bash
curl -LSso ~/bootstrap.sh https://raw.githubusercontent.com/Integralist/dotfiles/master/bootstrap.sh
/bin/bash bootstrap.sh
```

### Software

- Install Google Chrome (login and sync)
- AppStore: Slack, Twitter and Caffeine
- MacDown (http://macdown.uranusjr.com/)

### GitHub

- Setup ssh keys for github use:  
  ```bash
  cd ~/.ssh && sshkey # github_rsa
  ```
- Start the ssh-agent:  
  ```bash
  eval "$(ssh-agent -s)"
  ```
- Add the ssh key to the agent:  
  ```bash
  ssh-add -K ~/.ssh/github_rsa # -K for Mac OS X keychain persistence
  ```
- Get copy of public key:  
  ```bash
  pbcopy < ~/.ssh/github_rsa.pub # paste into GitHub GUI
  ```
- Test setup:  
  ```bash
  ssh -T git@github.com
  ```

> Note: you can also try out git-diff-fancy  
> `npm install -g diff-so-fancy`  
> One time: `git diff | diff-highlight | diff-so-fancy`  
> Permanent: `git config --global core.pager "diff-so-fancy | less --tabs=1,5 -R"`

### Miscellaneous

- Install "Box Sync" and "Dropbox"
- Then copy in your certificates:  
  ```bash
  mkdir -p ~/.pki/bbc
  ```
- Java JDK, [Vagrant](https://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- Golang
  - `go get golang.org/x/tools/cmd/goimports`
  - `mkdir -p ~/Projects/golang`
  - `go get github.com/svent/sift` (`sift --files 'c*\.go' -n package`)
