local awful = require("awful")
local mods = require("core.mods")
local apps = require("core.apps")
local modkey = mods.modkey
local widgets = require("ui")

-- AwesomeWM keybindings
awful.keyboard.append_global_keybindings({
	awful.key(
		{ modkey },
		"s",
		require("awful.hotkeys_popup").show_help,
		{ description = "Show help", group = "awesome" }
	),
	awful.key({ modkey }, "w", function()
		widgets.menu.main:show()
	end, { description = "Show main menu", group = "awesome" }),
	awful.key({ modkey, mods.ctrl }, "r", awesome.restart, { description = "Reload awesome", group = "awesome" }),
	awful.key({ modkey, mods.shift }, "q", awesome.quit, { description = "Quit awesome", group = "awesome" }),
	awful.key({ modkey }, "x", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "Execute Lua prompt", group = "awesome" }),
})

-- Launcher keybindings
awful.keyboard.append_global_keybindings({
	awful.key({ modkey }, "Return", function()
		awful.spawn(apps.terminal)
	end, { description = "Launch a terminal", group = "launcher" }),
	awful.key({ modkey }, "r", function()
		awful.screen.focused().mypromptbox:run()
	end, { description = "Run prompt", group = "launcher" }),
	awful.key({ modkey }, "p", function()
		awful.spawn("rofi -show drun")
	end, { description = "Show app launcher", group = "launcher" }),
})

-- Tag keybindings
awful.keyboard.append_global_keybindings({
	awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "View previous tag", group = "tag" }),
	awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "View next tag", group = "tag" }),
	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "Go back", group = "tag" }),
})

-- Client keybindings
awful.keyboard.append_global_keybindings({
	awful.key({ modkey }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "Focus next client by index", group = "client" }),
	awful.key({ modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "Focus previous client by index", group = "client" }),
	awful.key({ modkey }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, { description = "Go to previous client", group = "client" }),
	awful.key({ modkey, mods.ctrl }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:activate({ raise = true, context = "key.unminimize" })
		end
	end, { description = "Restore minimized client", group = "client" }),
	awful.key({ modkey, mods.shift }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "Swap with next client by index", group = "client" }),
	awful.key({ modkey, mods.shift }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "Swap with previous client by index", group = "client" }),
	awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "Jump to urgent client", group = "client" }),
})

-- Screen keybindings
awful.keyboard.append_global_keybindings({
	awful.key({ modkey, mods.ctrl }, "j", function()
		awful.screen.focus_relative(1)
	end, { description = "Focus the next screen", group = "screen" }),
	awful.key({ modkey, mods.ctrl }, "k", function()
		awful.screen.focus_relative(-1)
	end, { description = "Focus the previous screen", group = "screen" }),
})

-- Layout keybindings
awful.keyboard.append_global_keybindings({
	awful.key({ modkey }, "h", function()
		awful.tag.incmwfact(0.05)
	end, { description = "Increase master width factor", group = "layout" }),
	awful.key({ modkey }, "l", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "Decrease master width factor", group = "layout" }),
	awful.key({ modkey, mods.shift }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "Increase number of columns", group = "layout" }),
	awful.key({ modkey, mods.shift }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "Decrease number of columns", group = "layout" }),
	awful.key({ modkey }, "space", function()
		awful.layout.inc(1)
	end, { description = "Select next layout", group = "layout" }),
	awful.key({ modkey, mods.shift }, "space", function()
		awful.layout.inc(-1)
	end, { description = "Select previous layout", group = "layout" }),
})

-- Number-based keybindings
awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { modkey },
		keygroup = "numrow",
		description = "Only view tag",
		group = "tag",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				tag:view_only()
			end
		end,
	}),
	awful.key({
		modifiers = { modkey, mods.ctrl },
		keygroup = "numrow",
		description = "Toggle tag",
		group = "tag",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end,
	}),
	awful.key({
		modifiers = { modkey, mods.shift },
		keygroup = "numrow",
		description = "Move focused client to tag",
		group = "tag",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end,
	}),
	awful.key({
		modifiers = { modkey, mods.ctrl, mods.shift },
		keygroup = "numrow",
		description = "Toggle focused client on tag",
		group = "tag",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end,
	}),
	awful.key({
		modifiers = { modkey, mods.ctrl, mods.shift },
		keygroup = "numrow",
		description = "Toggle focused client on tag",
		group = "tag",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end,
	}),
	awful.key({
		modifiers = { modkey },
		keygroup = "numpad",
		description = "Select layout directly",
		group = "layout",
		on_press = function(index)
			local t = awful.screen.focused().selected_tag
			if t then
				t.layout = t.layouts[index] or t.layout
			end
		end,
	}),
})

-- fn-key keybindings
awful.keyboard.append_global_keybindings({
	awful.key({}, "XF86AudioMute", function()
		awful.util.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
	end, { description = "Toggle volume mute", group = "Fn-keys" }),
	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.util.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
	end, { description = "Increase volume", group = "Fn-keys" }),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.util.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
	end, { description = "Decrease volume", group = "Fn-keys" }),
	awful.key({}, "XF86MonBrightnessUp", function()
		awful.util.spawn("busctl --user call org.clight.clight /org/clight/clight org.clight.clight IncBl d 0.1")
	end, { description = "Increase brightness", group = "Fn-keys" }),
	awful.key({}, "XF86MonBrightnessDown", function()
		awful.util.spawn("busctl --user call org.clight.clight /org/clight/clight org.clight.clight DecBl d 0.1")
	end, { description = "Decrease brightness", group = "Fn-keys" }),
	awful.key({}, "XF86AudioPlay", function()
		awful.util.spawn("playerctl play-pause")
	end, { description = "Play/Pause audio", group = "Fn-keys" }),
	awful.key({}, "XF86AudioPrev", function()
		awful.util.spawn("playerctl previous")
	end, { description = "Previous audio track", group = "Fn-keys" }),
	awful.key({}, "XF86AudioNext", function()
		awful.util.spawn("playerctl next")
	end, { description = "Next audio track", group = "Fn-keys" }),
})
