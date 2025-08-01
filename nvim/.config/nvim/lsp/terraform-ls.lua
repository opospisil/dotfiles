return {
  cmd = { 'terraform-ls', 'serve' },                              -- Command to start the server
  filetypes = { 'terraform', 'tf' },                              -- Filetypes to attach the server to
  root_markers = { '.terraform', 'main.tf', 'modules/', '.git' }, -- Root directory markers
  settings = {
    terraform = {
      experimentalFeatures = {
        prefillRequiredFields = true, -- Enable autocompletion for required fields
        validateOnSave = true,        -- Run terraform validate on save
      },
    },
  },
}
