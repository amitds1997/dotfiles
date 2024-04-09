# Wayland setup

## Backlog

- Setup VPN
- Setup TV/Movies indexes
  - [PlexGuide](https://github.com/plexguide/PlexGuide.com)
  - [Automated usenet setup](https://blog.decryption.net.au/t/a-fully-automated-usenet-piracy-machine-with-plex-sabnzbd-and-sonarr/130)
- Setup anacron
- Revisit NVIDIA early KMS setup (if things can be removed from cmdline or not)
- Revisit how to setup hardware acceleration with NVIDIA in firefox
- Revisit
  - `bindl` events (e.g. lid close) - if we want to do it, how we want to do it?
  - How to leverage [Multiple actions](http://wiki.hyprland.org/Configuring/Binds/#multiple-binds-to-one-key)
  - Add screenshot bindings
  - If we still face clight too fast, too slow brigtness adjustment, fix it
  - Power optimization
    1. [Optimizing hyprland for power](http://wiki.hyprland.org/FAQ/#how-do-i-make-hyprland-draw-as-little-power-as-possible-on-my-laptop)
    2. Optimizing tlp
    3. Frequency CPU scaling (bring down power usage to 5-6W)

## Future tasks

1. Configure
   - Window swallowing
   - [automatic mounting (or atleast a notification)](https://wiki.hyprland.org/Useful-Utilities/Other/#automatically-mounting-using-udiskie)
   - AUR for font packages
2. Fix errors while booting up (if any)
3. How to logout properly? Currently, it logs out the user but hangs the system
4. The inbuilt microphone is not detected
5. Fix situation where when you open an image in Nemo (file manager),
   the image goes out of screen
6. Delete
   1. Awesomewm
   2. picom
   3. libinput-gestures (???)
   4. x11 packages
   5. /etc/X11/xorg.conf.d/30-touchpad.conf
7. Maybe [plugins](https://wiki.hyprland.org/Plugins/Using-Plugins/#getting-plugins)
   - [Awesomewm like workspaces](https://github.com/Duckonaut/split-monitor-workspaces?tab=readme-ov-file)
   - [i3 like workspaces](https://github.com/outfoxxed/hy3)
8. Try out
   - Automatically adjust brigtness [wluma](https://github.com/maximbaz/wluma?tab=readme-ov-file)
   - Gamma simulation: [hyprshade](https://github.com/loqusion/hyprshade)
   - Dim inactive windows: [hyprdim](https://github.com/donovanglover/hyprdim)

## To do

1. Configure
   - Bindings viewer (Low priority)
   - Find mouse cursor (cursor gets bigger on moving it rapidly)
   - `tlp-rdw` does not kill wifi on ethernet connection
   - Set up same time on windows and linux (prevent out of sync)
   - On audio device disconnect, pause the media (if playing)
   - Fix microphone not found when nothing is connected
2. Setup keybindings to
   - Switch b/w successive workspaces
   - Send window to monitor on the right or left
3. Fix clight not adjusting colors properly
4. Fix keyboard dropping off and not reconnecting (even if the
   cable is bad :/, it should reconnect automatically)
5. Integrate secrets for password in NetworkManager
6. enable system-resolvd.service
7. Reintegrate clight
