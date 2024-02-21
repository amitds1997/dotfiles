# TODO List

## Pending TODOs

- Set up AUR for font packages
- Make XOrg detect the correct DPI of each screen on launch and on monitor connect

## Possible issues

- Fix systemd-networkd-wait-online.service failing in `systemctl --type=service`
  output
- Fix NVIDIA drivers not loaded after tlp.service loading
- Fix the errors on startup log file that are shown when starting the laptop
- Fix tlp.service not automatically starting

## Backlog

- Setup VPN
- Setup TV/Movies indexes
  - [PlexGuide](https://github.com/plexguide/PlexGuide.com)
  - [Automated usenet setup](https://blog.decryption.net.au/t/a-fully-automated-usenet-piracy-machine-with-plex-sabnzbd-and-sonarr/130)
- Setup anacron
- Revisit NVIDIA early KMS setup (if things can be removed from cmdline or not)
- Revisit how to setup hardware acceleration with NVIDIA in firefox

## To do

- Setup
  1. [clight](./clight.md)
  2. [libinput-gestures](./libinput-gestures.md)
  3. [picom](./picom.md)
  4. [awesomewm](./awesomewm.md)
  5. geoclue
  6. rofi
  7. Fan speed control
- Configure
  1. Lid close, Lid open, Hibernate, Sleep
  2. Power handling
  3. Autolaunch awesomewm on start up without dropping into xinitrc
  4. Multi-monitor support (brightness)
  5. Battery monitor
  6. Keyboard backlight management
  7. Currently playing song/media (using playerctl)
- Go through following Arch wikis (Check additional articles linked at the end too)
  - Xorg
  - Power management
  - Power management/Wakeup triggers
  - Frequency CPU scaling
  - DPMS for monitors

## In progress
