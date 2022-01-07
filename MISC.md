## Wifi

It can be useful to create a symlink to the internal `airport` binary so you can control wifi from your terminal:

```bash
ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport /usr/local/bin/wifi
```

Results: 
- `wifi -s`: list available wifi networks.
- `wifi -I`: info on the current wifi connection.

> **NOTE**: [Reference](https://hashtagwifi.com/blog/using-airportd-in-terminal-on-macos-to-get-wifi-info).
