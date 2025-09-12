vim.opt_local.conceallevel = 3

local has_mini_ai, mini_ai = pcall(require, "mini.ai")
if has_mini_ai then
  vim.b.miniai_config = {
    custom_textobjects = {
      ["*"] = mini_ai.gen_spec.pair("*", "*", { type = "greedy" }),
      ["_"] = mini_ai.gen_spec.pair("_", "_", { type = "greedy" }),
    },
  }
end

local has_surround, mini_surround = pcall(require, "mini.surround")
if has_surround then
  vim.b.minisurround_config = {
    custom_surroundings = {
      B = {
        input = { "%*%*().-()%*%*" },
        output = { left = "**", right = "**" },
      },
      I = {
        input = { "%_().-()%_" },
        output = { left = "_", right = "_" },
      },
      M = {
        input = { "%`().-()%`" },
        output = { left = "`", right = "`" },
      },
      L = {
        input = { "%[().-()%]%(.-%)" },
        output = function()
          local link = mini_surround.user_input "Link: "
          return { left = "[", right = "](" .. link .. ")" }
        end,
      },
    },
  }
end
