local awful = require("awful")
local modkey = require("core.mods").modkey

return function(s)
	return awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = {
			-- Left-click = Switch to tag
			awful.button({}, 1, function(t)
				t:view_only()
			end),
			-- Mod + Left-click = Move focused client to the tag
			awful.button({ modkey }, 1, function(t)
				if client.focus then
					client.focus:move_to_tag(t)
				end
			end),
			-- Right-click = Make tag's content visible in the current one
			awful.button({}, 3, awful.tag.viewtoggle),
			-- Mod + Right-click = Make currently focused client also visible in the clicked tag (without moving it away from the current tag)
			awful.button({ modkey }, 3, function(t)
				if client.focus then
					client.focus:toggle_tag(t)
				end
			end),
			-- Mouse scroll switches to prev/next tags.
			awful.button({}, 4, function(t)
				awful.tag.viewprev(t.screen)
			end),
			awful.button({}, 5, function(t)
				awful.tag.viewnext(t.screen)
			end),
		},
	})
end
