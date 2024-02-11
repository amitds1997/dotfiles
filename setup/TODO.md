# TODO List

## Future plans

- Setup VPN
- Setup TV/Movies indexes
  - [PlexGuide](https://github.com/plexguide/PlexGuide.com)
  - [Automated usenet setup](https://blog.decryption.net.au/t/a-fully-automated-usenet-piracy-machine-with-plex-sabnzbd-and-sonarr/130)
- Setup anacron

## Backlog

- Setup
  1. [clight](./clight.md)
  2. [libinput-gestures](./libinput-gestures.md)
  3. [picom](./picom.md)
  4. [awesomewm](./awesomewm.md)
  5. geoclue
  6. rofi
- Set up reflector service to automatically update mirrorlist every week
- Set up AUR for font packages
- Add drivers for NVIDIA and AMD
- Make XOrg detect the correct DPI of each screen on launch and on monitor connect
- Find a way to register my 30-touchpad.conf that I put at /etc/X11/xorg.conf.d/30-touchpad.conf
- Configure
  1. Lid close
  2. Power handling
  3. Autolaunch awesomewm on start up without dropping into xinitrc
  4. Multi-monitor support (brightness)
  5. Battery monitor
  6. Keyboard backlight management
- Check how to enable AMD GPU for display
- Go through following Arch wikis (Check additional articles linked at the end too)
  - Xorg
  - Hardware video acceleration
  - Power management
  - Frequency CPU scaling
  - Laptop
  - pacman
    - Clean up package cache; setup regular cleanup
    - Report orphan packages
    - Report broken symlinks
    - On successful installation, add package to the ~/.pkglist.txt file
    - [GitHub gist](https://gist.github.com/rumansaleem/083187292632f5a7cbb4beee82fa5031)

## In progress

- Fix hardware acceleration (use NVIDIA GPU instead of AMD)
