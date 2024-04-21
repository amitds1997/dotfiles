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
- [ ] OSD
  - [ ] Volume
  - [ ] Brightness
  - [ ] Speaker muted
- [ ] Overview
  - [ ] Allow moving window from one workspace to other
  - [ ] Show layout and content in those windows
  - [ ] Attach it to three finger swipe up
- App launcher
  - [ ] Automatically highlight the first selected search item
  - [ ] Neovim does not launch. It works from the rofi menu
  - [ ] Allow bigger scroll for Application launcher
- Top bar
  - Right
    - Audio
      - [ ] Add application volume sink selector
    - WiFi/Ethernet
      - [ ] Right click opens settings
    - Bluetooth panel
      - Bluetooth device list
        - [ ] Filter out null name bluetooth devices
    - [ ] Quick access
      - Dark mode
        - [ ] Replace pywal with matugen and integrate with ags
        - [ ] Figure out how the colors change and adjust the toggle to
          apply the theme to the wider OS
      - Brightness
        - [ ] Do a gradual increase instead of a curve ball
      - Music player
        - [ ] If no icon is available drop the widget of icon
    - Battery
      - [ ] Add toggle to activate battery saving mode on click to battery
    - Power menu
      - [ ] Switch layout to horizontal for powermenu
