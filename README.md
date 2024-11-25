# dotfiles

The ultimate source of truth is this dotfile repo, all other published content is likely stale. This includes...

[This blog post](https://www.integralist.co.uk/posts/tools/) which gives a summary of all my favourite developer tools.

[This blog post](https://www.integralist.co.uk/posts/new-laptop-configuration/) which gives a detailed break down of how to set up a new macOS laptop.

[This gist](https://gist.github.com/Integralist/05e5415de6743e66b112574a1a5c1970) which gives a concise summary of the steps from the blog post.

## Terminal

As of Nov 2024 I'm using [Rio](https://raphamorim.io/rio/)

As of Dec 2023 I'll likely be using Ghostty.

### Prompt

![Terminal Prompt](./terminal-prompt-ui.png)

> \[!NOTE\]
> We need nerdfonts.com installed and selected as the terminal's font.\
> `brew install font-hack-nerd-font`\
> "Hack Nerd Font Mono"

### Tools

There is a [`Brewfile`](./Brewfile) which can help you install any programs that were installed via Homebrew:

```bash
brew bundle dump --force
brew bundle install
```

### Developer Mode

> \[!WARNING\]
> I'm not sure if this is still relevant with the change over in terminals and
> OS versions.

To enable developer mode:

```bash
spctl developer-mode enable-terminal
```

Turning this feature on has been shown to improve the speed of certain terminal operations like running Rust compilation.

### OS Wake Up

To improve your retina macOS 'wake-up from sleep' performance:

```bash
sudo pmset -a standbydelay 7200
```

The larger the number (time in seconds), the longer it will take macOS to switch into 'standby mode'. This mode takes a while to 'wake up' before you can log back in, and people tend to prefer delaying it for as long as possible ([reference](https://www.cultofmac.com/221392/quick-hack-speeds-up-retina-macbooks-wake-from-sleep-os-x-tips/)).

## GUI

- [Android File Transfer](https://www.android.com/filetransfer/): `brew install --cask android-file-transfer`
- [Rio Terminal](https://raphamorim.io/rio/): `brew install --cask rio`
- [Warp Terminal](https://www.warp.dev/): `brew install --cask warp`.
- [alltomp3](https://alltomp3.org/): for backing up Spotify music.
- [makemkv](https://makemkv.com/): rip DVDs and Blu-ray discs.
- [monosnap](https://monosnap.com/): annotate images.
- [owly](https://apps.apple.com/us/app/owly-display-sleep-prevention/id882812218): prevent screen going to sleep.
