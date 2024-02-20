-- Allow all signals to be connected and/or emitted
return {
	client = require(... .. ".client"),
	-- `tag` must be loaded before the `screen` so that correct layouts are appended to the tags upon creation.
	tag = require(... .. ".tag"),
	screen = require(... .. ".screen"),
}
