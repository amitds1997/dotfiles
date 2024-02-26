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
11. Install [authentication agent](http://wiki.hyprland.org/Useful-Utilities/Must-have/#authentication-agent)
12. Install [hyprshade](https://github.com/loqusion/hyprshade) for gamma simulation

## To do

1. Setup status bar
2. Setup
   1. fn-keys
   2. [clight](./clight.md)
   3. rofi
   4. geoclue
   5. `grim` and `slurp` to make screenshotting work
   6. screen recording
   7. screen sharing
   8. screen locking
   9. OSD (for example when CAPS-lock or num-lock is on)
3. Setup
   1. display manager
   2. idle daemon (Check awesome-hyprland page for more info)
   3. clipboard manager
   4. wallpaper handler
   5. colorpicker
   6. Bindings viewer
   7. `bindl` switches (e.g. with lid close)
   8. [Multiple actions](http://wiki.hyprland.org/Configuring/Binds/#multiple-binds-to-one-key)
   9. Setup pywal
4. Setup
   1. Mouse pointer to get bigger so that it is easy to find on quick zig-zag
   2. dunst
   3. Setup [candy-icons](https://github.com/EliverLara/candy-icons) theme
   4. DPMS
5. Delete
   1. Awesomewm
   2. picom
   3. libinput-gestures (???)
6. Configure
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
7. Go through following Arch wikis (Check related articles too)
   - Xorg
   - Power management
   - Power management/Wakeup triggers
   - Frequency CPU scaling (bring down power usage to 5-6W)
   - DPMS for monitors
8. Checkout [awesome-hyperland](https://github.com/hyprland-community/awesome-hyprland)
9. Fix firefox crashing on opening maps
