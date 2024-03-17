return function(interpreter_path)
  return {
    settings = {
      pyright = {
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          autoImportCompletions = true,
          autoSearchPaths = true,
          typeCheckingMode = "standard",
          diagnosticMode = "workspace",
          -- Add rules from here: https://microsoft.github.io/pyright/#/configuration?id=type-check-diagnostics-settings
          diagnosticSeverityOverrides = {},
        },
        pythonPath = interpreter_path,
      },
    },
  }
end
