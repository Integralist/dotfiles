# dotfiles

> \[!TIP\]
> Clone this repo to `~/code/dotfiles` then symlink files.\
> e.g. `ln -s ~/code/dotfiles/.config ~/.config`

The ultimate source of truth is this dotfile repo, all other published content is likely stale. This includes...

[This blog post](https://www.integralist.co.uk/posts/dev-tools/) which gives a summary of all my favourite developer tools.

[This blog post](https://www.integralist.co.uk/posts/laptop-setup-v2) which gives a detailed break down of how to set up a new macOS laptop.

[This gist](https://gist.github.com/Integralist/05e5415de6743e66b112574a1a5c1970) which gives a concise summary of the steps from the blog post.

## Terminal

As of 2022 I'm using [Warp](https://www.warp.dev/).

As of Nov 2024 I'm using [Rio](https://raphamorim.io/rio/).

As of Dec 2024 I'm using [Ghostty](https://ghostty.org/).

### Prompt

![Terminal Prompt](./terminal-prompt-ui.png)

> \[!NOTE\]
> If using Ghostty, it comes with Nerd Fonts installed `ghostty +list-fonts`.\
> Otherwise you'll need [nerdfonts.com](https://www.nerdfonts.com/) installed and selected as the terminal's font.\
> e.g. `brew install font-hack-nerd-font`\
> Will install "Hack Nerd Font Mono".

## Tools

There is a [`Brewfile`](./Brewfile) which can help you install any programs that were installed via Homebrew:

```bash
brew bundle dump --force
brew bundle install
```

## GUIs

- [Android File Transfer](https://www.android.com/filetransfer/): `brew install --cask android-file-transfer`
- [Rio Terminal](https://raphamorim.io/rio/): `brew install --cask rio`
- [Warp Terminal](https://www.warp.dev/): `brew install --cask warp`.
- [goread](https://github.com/TypicalAM/goread): `brew install goread`.
- [alltomp3](https://alltomp3.org/): for backing up Spotify music.
- [makemkv](https://makemkv.com/): rip DVDs and Blu-ray discs.
- [flameshot](https://flameshot.org/): annotate images.
- [owly](https://apps.apple.com/us/app/owly-display-sleep-prevention/id882812218): prevent screen going to sleep.
