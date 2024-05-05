return {
  basedpyright = {
    disableOrganizeImports = true,
    analysis = {
      typeCheckingMode = "standard",
      useLibraryCodeForTypes = true, -- Analyze library code for type information
      autoImportCompletions = true,
      autoSearchPaths = true,
      diagnosticSeverityOverrides = {},
    },
  },
}
