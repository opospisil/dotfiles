local capabilities = {
  textDocument = {
    foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    },
  },
}


capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.diagnostic.config({
      virtual_lines = { current_line = true }
    })

    vim.lsp.config("*", {
      capabilities = capabilities,
      root_markers = { ".git" },
    })

    -- Go
    vim.lsp.config('gopls', {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    })

    -- Nix
    vim.lsp.config('nil-ls', {
      autostart = true,
      filetypes = { 'nix' },
      cmd = { "nil" },
      settings = {
        ['nil'] = {
          testSetting = 42,
          formatting = {
            command = { "nixfmt" },
          },
        },
      },
    })

    -- Lua
    vim.lsp.config('lua_ls', {
      autostart = true,
      settings = { -- custom settings for lua
        Lua = {
          -- make the language server recognize "vim" global
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            -- make language server aware of runtime files
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    vim.lsp.enable('lua_ls')
    vim.lsp.enable('gopls')
    vim.lsp.enable('nil-ls')
    vim.lsp.enable('terraform-ls')
    --vim.lsp.enable('clangd')
    --vim.lsp.enable('ansible')
  end,
  lazy = false,
  dependencies = {
    "windwp/nvim-autopairs",
  },
}
