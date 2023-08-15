local built_in = require("telescope.builtin")

return {
  ["<Leader>t"] = {
    name = "+telescope",
    f = { built_in.find_files, "Find file" },
    r = { built_in.oldfiles, "Open recent file" },
    g = { built_in.git_files, "Find file in git repo" },
    w = { built_in.live_grep, "Find word" },
    b = { built_in.buffers, "Select from open buffers" },
    k = { built_in.keymaps, "Open keymap window" },
    ["/"] = { built_in.current_buffer_fuzzy_find, "Fuzzy find in the current buffer" },
  }
}
