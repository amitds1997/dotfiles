local function project_config()
  require("project_nvim").setup()
end

return {
  "ahmedkhalf/project.nvim",
  config = project_config,
}
