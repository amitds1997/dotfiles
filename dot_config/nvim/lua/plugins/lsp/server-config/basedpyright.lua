return function(interpreter_path)
  return {
    settings = {
      basedpyright = {
        disableOrganizeImports = true,
        analysis = {
          autoImportCompletions = true,
          autoSearchPaths = true,
          typeCheckingMode = "standard",
          diagnosticMode = "workspace",
          -- Add rules from here: https://microsoft.github.io/pyright/#/configuration?id=type-check-diagnostics-settings
          diagnosticSeverityOverrides = {},
        },
      },
      python = {
        pythonPath = interpreter_path,
      },
    },
  }
end
