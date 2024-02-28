# Wayland setup

## Backlog

- Setup VPN
- Setup TV/Movies indexes
  - [PlexGuide](https://github.com/plexguide/PlexGuide.com)
  - [Automated usenet setup](https://blog.decryption.net.au/t/a-fully-automated-usenet-piracy-machine-with-plex-sabnzbd-and-sonarr/130)
- Setup anacron
- Revisit NVIDIA early KMS setup (if things can be removed from cmdline or not)
- Revisit how to setup hardware acceleration with NVIDIA in firefox

## Future tasks

01. Set up AUR for font packages
02. Detect correct DPI for each screen on launch and monitor connect
03. Setup more gestures
    1. Workspace quick switch
    2. Screen switch
04. Fix errors while booting up (if any)
05. Setup hardware video acceleration for Firefox, VLC and others
06. Delete /etc/X11/xorg.conf.d/30-touchpad.conf
07. Delete x11 packages
08. Enable(??) window swallowing
09. Enable [automatic mounting (or atleast a notification)](https://wiki.hyprland.org/Useful-Utilities/Other/#automatically-mounting-using-udiskie)
10. Add [plugins](https://wiki.hyprland.org/Plugins/Using-Plugins/#getting-plugins)
11. Install [hyprshade](https://github.com/loqusion/hyprshade) for gamma simulation

## To do

1. Setup
   1. `grim` and `slurp` to make screenshotting work
   2. screen recording
   3. screen sharing
   4. screen locking
   5. [clight](./clight.md)
   6. rofi
   7. geoclue
   8. OSD (for example when CAPS-lock or num-lock is on)
2. Setup
   1. display manager
   2. idle daemon (Check awesome-hyprland page for more info)
   3. clipboard manager
   4. colorpicker
   5. Bindings viewer
   6. `bindl` switches (e.g. with lid close)
   7. [Multiple actions](http://wiki.hyprland.org/Configuring/Binds/#multiple-binds-to-one-key)
3. Setup
   1. Mouse pointer to get bigger so that it is easy to find on quick zig-zag
   2. dunst
   3. Notifications whenever volume or brightness are adjusted showing level
   4. Setup [candy-icons](https://github.com/EliverLara/candy-icons) theme
   5. DPMS
4. Delete
   1. Awesomewm
   2. picom
   3. libinput-gestures (???)
5. Configure
   1. Lid close, Lid open, Hibernate, Sleep
   2. Power handling
      1. [Optimizing hyprland for power](http://wiki.hyprland.org/FAQ/#how-do-i-make-hyprland-draw-as-little-power-as-possible-on-my-laptop)
      2. Optimizing tlp
      3. Any other methods
   3. Autolaunch awesomewm on start up without dropping into xinitrc
   4. Multi-monitor support (brightness)
   5. Battery monitor
   6. Keyboard backlight management
   7. Currently playing song/media (using playerctl)
   8. Set up Do not disturb mode
6. Go through following Arch wikis (Check related articles too)
   - Xorg
   - Power management
   - Power management/Wakeup triggers
   - Frequency CPU scaling (bring down power usage to 5-6W)
   - DPMS for monitors
7. Checkout [awesome-hyperland](https://github.com/hyprland-community/awesome-hyprland)
8. Fix firefox crashing on opening maps
