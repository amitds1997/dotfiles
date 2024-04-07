# To do list

## Next in line

- [ ] Fix OSD

## Fixes

- [ ] Fix logout kernel panic and logic handling of closing windows before
  shutdown, reboot, hibernate, etc.
- [ ] In application selector, automatically select the top
  result; Enter should launch it
- [ ] Fix wifi menu
- [ ] Fix bluetooth menu
- [ ] Fix settings (use a single icon of settings)
- [ ] Fix appmixer
- [ ] Fix sink selector
- [ ] Fix Neovim not opening from app launcher
- [ ] Fix widget destruction in
  - Screen recorder (after recording completion)
  - Systray (after quitting the apps through systray)
- [x] Fix colorpicker notification
- [x] Add tooltip to battery showing how much time is remaining
- [x] Fix music player icon not hiding when no music is playing
- [x] Fix music player layout
- [x] Fix microphone
- [x] Fix speaker/microphone icons
- [x] Use numbers in hyprland workspaces

## New features

- [ ] Add volume, brightness OSD
- [ ] Add source selector
- [ ] Add NumLock, CapsLock, Microphone, Camera indicator, Screen
  recording indicator (with a bright color)
- [ ] Set transition for closing pop down windows
- [ ] Add launcher icon (hyprland icon to the left)
- [ ] Inhibit flag?
- [ ] Switch b/w light and dark mode?
- [ ] Add Brightness widget
- [ ] Replace pywal with matugen and integrate with ags
- [ ] Replace rofi-wallpaper with ags
- [ ] Add notifications when your battery is low
- [ ] Instead of exiting when shutting down, give apps some time to quit (pls!)
- [ ] Allow bigger scroll for Application launcher
- [ ] In music player, if no icon is available drop the widget of icon
- [ ] Add tomato timer similar to [Tomato.C](https://github.com/gabrielzschmitz/Tomato.C)
- [ ] Window tab to switch b/w active windows
- [ ] Make it so that ags when adjusting brightness adjusts it only for the
  monitor it is on
- [ ] Display manager

## Priority, but would need more than config change

- [ ] Fix ethernet icon (broken because well we get the wrong details)

## Cleanup

- [ ] Use window previews on the previews (Do I need this at all?)

## Later

- [ ] Switch layout to vertical for powermenu
- [ ] Toggle the drop menu on clicks without having to move cursor
- [ ] Fix calendar highlighting dates even when month is changed
  (requires GTK4 from my investigation)

## Structure

- Left
  - Hyprland workspaces
  - Pending notifications
- Center
  - Date & time
    - Notifications
    - Panel
      - Time (with seconds)
      - Calendar
- Right
  - (If active) screen recording (blinking and red)
  - (If active) microphone (not blinking but bright orange)
  - (If active) camera (not blinking but bright green)
  - System tray
  - Volume
    - Default speaker volume (with percentage number)
    - Default microphone volume (with percentage number)
    - Applications (App Mixer)
    - Input selector
    - Output selector
  - WiFi/Ethernet
    - Panel
      - On/off toggle
      - Re-scan
      - Lock current network
    - Available WiFi List
      - Known networks
      - Found networks
    - (Right-button-click shows active network details)
  - Bluetooth panel
    - Panel
      - On/off toggle
      - Re-scan
    - Bluetooth device list
      - Known devices
      - Found devices
    - (Right-button-click shows active Bluetooth details)
  - Quick access
    - Panel
      - Color picker
      - Screenshot
      - Screen recorder
      - Do not disturb
      - Dark mode
      - Brightness
        - Pause auto-adjust
        - Selector for each monitor
    - Music player
  - Battery
    - Toggle to activate battery saving mode
  - Power menu
