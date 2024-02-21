local awful = require("awful")

awful.spawn.once("picom -b") -- Compositor
awful.spawn.once("playerctld daemon") -- To keep track of playing audio
awful.spawn.once("libinput-gestures-setup autostart start") -- Automatically start gestures
