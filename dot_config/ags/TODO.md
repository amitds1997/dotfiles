# To do list

## Last items

- [ ] OSD
  - [ ] NumLock
  - [ ] CapsLock
- [ ] Transient widgets
  - [ ] NumLock
  - [ ] Camera (would need to figure out the correct way to get this information)

## Known bugs

- [ ] Fix screenrecording error. Steps to reproduce
  1. Record anything
  2. From the notification, select play or view
  3. It opens in VLC, on each repeated play the following
     warning is generated: `(com.github.Aylur.ags:58137): LIBDBUSMENU-GLIB-WARNING  **: 04:47:39.596: Unable to replace properties  on 0: Error getting properties for ID`
- [ ] Ethernet service does not work correctly, the service returns nothing
- [ ] The open popup menu cannot be toggled without moving cursor

## General tasks

- [ ] Fix calendar highlighting dates even when month is changed
  (requires GTK4 from my investigation)
- [ ] Set transition for closing pop down windows
- [ ] When adjusting brightness, it only adjusts it on the active window
- [ ] Replace rofi-wallpaper with ags
- [ ] Window tab to switch b/w active windows
- [ ] Replace ddcutil by ddcutil-service
- [ ] Instead of exiting when shutting down, give apps some time to quit (pls!)
- [ ] Add notifications when your battery is low

## Pending tasks

- [ ] Login manager (Display manager)
- [x] App launcher
  - [ ] Automatically select the first available result
  - [ ] Neovim does not launch. It works from the rofi menu
  - [ ] Allow bigger scroll for Application launcher
- [ ] OSD
  - [ ] Volume
  - [ ] Brightness
  - [ ] Speaker muted
- [ ] Overview
  - [ ] Allow moving window from one workspace to other
  - [ ] Show layout and content in those windows
  - [ ] Attach it to three finger swipe up
- [ ] Top bar
  - [ ] Left
    - [ ] Hyprland workspaces
    - [ ] Pending notifications
  - [x] Center
    - [x] Date & time
      - [x] Notifications
      - [x] Panel
        - [x] Time (with seconds)
        - [x] Calendar
  - [x] Right
    - [x] Transient widgets
      - [x] Screen recording (blinking and red)
      - [x] Microphone (not blinking but bright orange)
    - [x] System tray
    - [x] Color picker
      - [x] Fix colorpicker notification
    - [x] Volume
      - [x] Default speaker volume (with percentage number)
      - [x] Default microphone volume (with percentage number)
      - [x] Applications (App Mixer)
      - [x] Input selector
      - [x] Output selector
      - [ ] Add application volume selector
    - [x] WiFi/Ethernet
      - [x] Panel
        - [x] On/off toggle
        - [x] Re-scan
      - [x] Available WiFi List
      - [ ] (Right-button-click shows active network details)
    - [x] Bluetooth panel
      - [x] Panel
        - [x] On/off toggle
        - [x] Re-scan (available through app)
      - [x] Bluetooth device list
        - [x] Known devices
        - [x] Found devices
        - [ ] Filter out null name bluetooth devices maybe?
    - [ ] Quick access
      - [x] Panel
        - [x] Screenshot
        - [x] Screen recorder
        - [x] Do not disturb
        - [x] Dark mode
          - [ ] Replace pywal with matugen and integrate with ags
          - [ ] Figure out how the colors change and adjust the toggle to
            apply the theme to the wider OS
        - [x] Brightness
          - [x] Pause auto-adjust
          - [x] Selector for each monitor
          - [ ] Do a gradual increase instead of a curve ball
      - [x] Music player
        - [x] Fix music player icon not hiding when no music is playing
        - [x] Fix music player layout
        - [ ] If no icon is available drop the widget of icon
    - [x] Battery
      - [ ] Add toggle to activate battery saving mode on click to battery
      - [x] Add tooltip to battery showing how much time is remaining
    - [x] Power menu
      - [ ] Switch layout to vertical for powermenu
