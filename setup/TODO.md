# TODO List

## Future plans

- Setup VPN
- Setup TV/Movies indexes
  - [PlexGuide](https://github.com/plexguide/PlexGuide.com)
  - [Automated usenet setup](https://blog.decryption.net.au/t/a-fully-automated-usenet-piracy-machine-with-plex-sabnzbd-and-sonarr/130)
- Setup anacron
- Revisit NVIDIA early KMS setup (if things can be removed from cmdline or not)
- Revisit how to setup hardware acceleration with NVIDIA in firefox

## Backlog

- Setup
  1. [clight](./clight.md)
  2. [libinput-gestures](./libinput-gestures.md)
  3. [picom](./picom.md)
  4. [awesomewm](./awesomewm.md)
  5. geoclue
  6. rofi
  7. Fan speed control
- Set up reflector service to automatically update mirrorlist every week
- Set up AUR for font packages
- Add drivers for NVIDIA and AMD
- Make XOrg detect the correct DPI of each screen on launch and on monitor connect
- Find a way to register my 30-touchpad.conf that I put at /etc/X11/xorg.conf.d/30-touchpad.conf
- Setup correct GPU launch
  1. VLC to launch with prime-run
- Configure
  1. Lid close, Lid open, Hibernate, Sleep
  2. Power handling
  3. Autolaunch awesomewm on start up without dropping into xinitrc
  4. Multi-monitor support (brightness)
  5. Battery monitor
  6. Keyboard backlight management
- Check how to enable AMD GPU for display
- Go through following Arch wikis (Check additional articles linked at the end too)
  - Xorg
  - Power management
  - Frequency CPU scaling
  - Power management/Wakeup triggers
  - systemd
  - pacman
    - Clean up package cache; setup regular cleanup
    - Report orphan packages
    - Report broken symlinks
    - On successful installation, add package to the ~/.pkglist.txt file
    - [GitHub gist](https://gist.github.com/rumansaleem/083187292632f5a7cbb4beee82fa5031)
- Fix the errors on startup log file that are shown when starting the laptop
- Fix tlp.service not automatically starting
- Fix network-online.service failing in `systemctl --type=service` output
- Fix NVIDIA drivers not loaded after tlp.service loading

## In progress
