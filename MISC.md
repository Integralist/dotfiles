## Wifi

It can be useful to create a symlink to the internal `airport` binary so you can control wifi from your terminal:

```bash
ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport /usr/local/bin/wifi
```

Results:

- `wifi -s`: list available wifi networks.
- `wifi -I`: info on the current wifi connection.

> **NOTE**: [Reference](https://hashtagwifi.com/blog/using-airportd-in-terminal-on-macos-to-get-wifi-info).

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
