# dotfiles

Read [this post](https://www.integralist.co.uk/posts/new-laptop-configuration/) for a detailed setup of a new laptop.

Follow [this gist](https://gist.github.com/Integralist/05e5415de6743e66b112574a1a5c1970) for a concise summary of steps.

In general the blog post is stale. The gist should be up-to-date. 

I would suggest reading the blog post for things that require more manual steps, like setting up a password store.

## Terminal

> **NOTE**: Refer to the [gist](https://gist.github.com/Integralist/05e5415de6743e66b112574a1a5c1970) for setup instructions, as most tools below are easily installed using Homebrew.

### Developer Mode

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

### Tools

There is a [`Brewfile`](./Brewfile) which can help you install any programs that were installed via Homebrew:

```bash
brew bundle install
```

In the following list of tools the ❌ indicates what _isn't_ installed via the [`Brewfile`](./Brewfile).

- [alacritty](https://github.com/alacritty/alacritty/blob/master/INSTALL.md#macos): cross-platform, OpenGL terminal emulator written in Rust.
- [asciinema](https://asciinema.org/): record your terminal screen.
- [bandwhich](https://github.com/imsnif/bandwhich): displays network utilization by process, connection and remote IP/hostname.
- [bat](https://github.com/sharkdp/bat): rust replacement for `cat`.
- [bottom](https://github.com/ClementTsang/bottom): replaces `top` and `htop` (executable is `btm` so alias `top` to that).
- [broot](https://github.com/Canop/broot): like `tree` but doesn't scroll endlessly, and has other navigational features.
- [delta](https://github.com/dandavison/delta): a better `diff` tool that can be used standalone or configured for use with `git`.
- [dog](https://github.com/ogham/dog): replaces `dig` with `dog`.
- [dust](https://github.com/bootandy/dust): replaces `du` for displaying disk usage statistics.
- [exa](https://github.com/ogham/exa): rust replacement for `ls`.
- [fd](https://github.com/sharkdp/fd): find replacement (not quite as powerful, but basically what I typically use find for).
- [fig](https://fig.io/): shell command completion.
- [fnm](https://github.com/Schniz/fnm): fast Node.js manager.
- [gping](https://github.com/orf/gping): replaces `ping` with tui graph version (executable is `gping` so alias `ping` to that).
- [grc](https://github.com/garabik/grc): generic colouriser for your shell (e.g. `alias go='grc /usr/bin/go'`), you can `brew install grc`.
- [hyperfine](https://github.com/sharkdp/hyperfine): benchmark your shell performance (e.g. `hyperfine 'bash -l'`).
- [imgcat](https://github.com/eddieantonio/imgcat): tool for viewing images in your terminal.
- [mdless](https://brettterpstra.com/projects/mdless/): tool for viewing Markdown files ❌.
- [panicparse](https://github.com/maruel/panicparse): Parses golang panic stack traces ❌.
- [procs](https://github.com/dalance/procs): rust replacement for `ps aux`.
- [rip](https://github.com/nivekuil/rip): replaces `rm` and allows restoring deleted files.
- [sad](https://github.com/ms-jpq/sad): interactive sed replacement (use `<Tab>` to select files to apply changes to).
- [sd](https://github.com/chmln/sd): sed replacement (not quite as powerful, but basically what I typically use sed for).
- [starship](https://starship.rs/): minimal, blazing-fast, and infinitely customizable prompt for any shell ([font settings](./.alacritty.yml)).
- [t-rec](https://github.com/sassman/t-rec-rs): record your terminal screen (outputs gif and mp4 unlike asciinema).
- [tldr](https://github.com/isacikgoz/tldr): summarizes useful features of commands.
- [tokei](https://github.com/XAMPPRocky/tokei): displays statistics about your code projects.
- [tuifeed](https://github.com/veeso/tuifeed): terminal RSS reader.
- [zoxide](https://github.com/ajeetdsouza/zoxide): directory switcher (`zoxide query -ls` shows db content).

> **NOTE**: tuifeed config is stored in `/Users/integralist/Library/Application Support/tuifeed/config.toml` (a copy is in this repo at `tuifeed.config.toml`).

## GUI

- [FreeTube](https://github.com/FreeTubeApp/FreeTube): YouTube without advertisements and no Google tracking.
- [alltomp3](https://alltomp3.org/): for backing up Spotify music.
- [bitbar/xbar](https://xbarapp.com/): gui for installing 'menu bar' apps ([github repo](https://github.com/matryer/xbar)).
- [handshaker](https://apps.apple.com/us/app/handshaker-manage-your-android-phones-at-ease/id1012930195?mt=12): manage videos/photos for your Android phone.
- [meeting bar](https://github.com/leits/MeetingBar): shows calendar meetings in macOS menu bar ([guide](https://support.google.com/calendar/answer/99358?co=GENIE.Platform%3DDesktop&hl=en)).
- [menu hidden](https://github.com/dwarvesf/hidden): macOS utility that helps hide menu bar icons.
- [monosnap](https://monosnap.com/): annotate images.
- [owly](https://apps.apple.com/us/app/owly-display-sleep-prevention/id882812218): prevent screen going to sleep.
- [tor browser](https://www.torproject.org/download/): tor/onion relay browser.

### Firefox Extensions

- [Dark Reader](https://addons.mozilla.org/en-GB/firefox/addon/darkreader/): switches websites to a dark theme to help your eyes.
- [Enhancer for YouTube](https://addons.mozilla.org/en-GB/firefox/addon/enhancer-for-youtube/): block ads on YouTube.
- [Facebook Container](https://addons.mozilla.org/en-GB/firefox/addon/facebook-container/): extra protection against FB tracking (instagram will open in this container type).
- [ModHeader](https://addons.mozilla.org/en-GB/firefox/addon/modheader-firefox/): modify HTTP request/response headers.
- [Multi-Account Containers](https://addons.mozilla.org/en-GB/firefox/addon/multi-account-containers/): define unique browser streams.
- [Privacy Badger](https://addons.mozilla.org/en-GB/firefox/addon/privacy-badger17/): block trackers.
- [Redirector](https://addons.mozilla.org/en-GB/firefox/addon/redirector/) configure custom URL redirects
- [Temporary Containers](https://addons.mozilla.org/en-US/firefox/addon/temporary-containers/): similar to multi-account-container, except each tab is a unique container instance.
- [uBlock Origin](https://addons.mozilla.org/en-GB/firefox/addon/ublock-origin/): block ads.
