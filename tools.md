## Dual monitors
- tweak direction and other features
    - arandr (GUI)
    - mons (CLI)
- save monitor setup conf
    - autorandr
- run after setting up dual monitors to fix backgroud issue:
    - feh --bg-scale /path/to/image.jpg

## Network
- gui: `nmtui`

### Autorandr
- script after loading the settings
    - put following commands into files named `postswitch` in `~/.config/autorandr/` folder

```{sh}
#!/bin/bash
feh --bg-scale ~/workData/wallpaper/20240414_182143.jpg

i3-msg restart
```

## Input
- set the config for input (e.g. fcitx5) to `.xprofile` in order to apply the setting to global
    - not setting in `.bashrc` or `.zshrc`

## commands
- Use following commands to list the folder based on size and get the top 10

```{sh}
du -hs $(ls -A) | sort -rh | head -10
```

## zsh theme

- powerlevel10k: https://github.com/romkatv/powerlevel10k
