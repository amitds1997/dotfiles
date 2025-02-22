return {
	Lua = {
		runtime = {
			version = "LuaJIT",
		},
		hint = {
			enable = true,
			arrayIndex = "Disable",
			semicolon = "Disable",
			setType = true,
		},
		format = {
			-- stylua runs using conform
			enable = false,
		},
		codeLens = {
			enable = true,
		},
		diagnostics = {
			disable = {
				"unused-local", -- Covered by selene.
			},
		},
	},
	workspace = {
		vim.env.VIMRUNTIME,
	},
}

