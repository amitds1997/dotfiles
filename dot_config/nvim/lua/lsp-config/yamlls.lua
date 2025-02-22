return {
  yaml = {
    hover = true,
    completion = true,
    validate = true,
    schemaStore = {
      enable = false,
      url = "",
    },
    schemas = require("schemastore").yaml.schemas(),
  },
}