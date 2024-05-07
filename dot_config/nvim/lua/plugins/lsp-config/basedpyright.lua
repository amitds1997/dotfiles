return {
  basedpyright = {
    disableOrganizeImports = true,
    disableTaggedHints = false,
    analysis = {
      typeCheckingMode = "standard",
      useLibraryCodeForTypes = true, -- Analyze library code for type information
      autoImportCompletions = true,
      autoSearchPaths = true,
      diagnosticSeverityOverrides = {
        reportIgnoreCommentWithoutRule = true,
      },
    },
  },
}
