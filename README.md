# dotfiles

Read [this post](https://www.integralist.co.uk/posts/new-laptop-configuration/) for a detailed setup of a new laptop.

Follow [this gist](https://gist.github.com/Integralist/05e5415de6743e66b112574a1a5c1970) for a simple summary of what to do (for my benefit primarily).

> Note: there is also an older/outdated [gist](https://gist.github.com/Integralist/20e6e0206f39d88302d73282688111a4), so choose the post over the gist.

## UPDATES

This section will reference any tools or information I've recently discovered, that aren't mentioned in the above gist (nor in my related [blog post](https://www.integralist.co.uk/posts/new-laptop-configuration/)) and I've considered not important enough to necessarily install or fix by default (hence not updating the relevant gist/post to include them).

- [owly](https://apps.apple.com/us/app/owly-display-sleep-prevention/id882812218): prevent screen going to sleep.
- [tor browser](https://www.torproject.org/download/): tor/onion relay browser.
- [`mdless`](https://brettterpstra.com/projects/mdless/): tool for viewing Markdown files in a terminal (provides way to list headers and to filter only specific content).
- [`imgcat`](https://github.com/eddieantonio/imgcat): tool for viewing images in your terminal.
- [handshaker](https://apps.apple.com/us/app/handshaker-manage-your-android-phones-at-ease/id1012930195?mt=12): manage videos/photos for your Android phone.
- [alltomp3](https://alltomp3.org/): for backing up Spotify music.
- [improve retina macOS wake-up from sleep performance](http://www.cultofmac.com/221392/quick-hack-speeds-up-retina-macbooks-wake-from-sleep-os-x-tips/): `sudo pmset -a standbydelay <time in seconds:7200>`
- [meeting bar](https://github.com/leits/MeetingBar): `brew cask install meetingbar` shows calendar meetings in macOS menu bar (make sure to [connect Google calendar to macOS calendar](https://support.google.com/calendar/answer/99358?co=GENIE.Platform%3DDesktop&hl=en)).
- [monosnap](https://monosnap.com/): annotate images.
- [menu hidden](https://github.com/dwarvesf/hidden): macOS utility that helps hide menu bar icons.
- [FreeTube](https://github.com/FreeTubeApp/FreeTube): Use YouTube without advertisements and prevent Google from tracking you

> Note: create a symlink to the internal `airport` binary so you can control wifi from your terminal: `ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport /usr/local/bin/wifi`, like: `wifi -s` to list available WiFi networks, and `wifi -I` to get info on the current WiFi connection ([this post](https://hashtagwifi.com/blog/using-airportd-in-terminal-on-macos-to-get-wifi-info) has more tricks and tips).

### Firefox Extensions

- [Dark Reader](https://addons.mozilla.org/en-GB/firefox/addon/darkreader/)
- [ExpressVPN](https://addons.mozilla.org/en-GB/firefox/addon/expressvpn/)
- [ModHeader](https://addons.mozilla.org/en-GB/firefox/addon/modheader-firefox/)
- [Privacy Badger](https://addons.mozilla.org/en-GB/firefox/addon/privacy-badger17/)
- [Redirector](https://addons.mozilla.org/en-GB/firefox/addon/redirector/) (useful for fixing internal company url proxies, like http://go/foo, when using a VPN)
- [uBlock Origin](https://addons.mozilla.org/en-GB/firefox/addon/ublock-origin/)
- [Enhancer for YouTube](https://addons.mozilla.org/en-GB/firefox/addon/enhancer-for-youtube/): block ads on YouTube.
